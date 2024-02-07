//
//  DSSLocationManager.swift
//  DSSFramework
//
//  Created by David on 27/12/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import CoreLocation
import MapKit

public class DSSLocationManager: NSObject, DSSNotificationHandler {
    public enum LocationNotification: String, DSSNotificationNameGenerator {
        public typealias Handler = DSSLocationManager
        case didUpdateLocation
        case didExitRegion
    }
    
    public enum LocationRequestSource {
        case `default`, background
    }
    
    public enum AccessType: CaseIterable {
        case always, whenInUse
        
        var status: CLAuthorizationStatus {
            switch self {
            case .always: return .authorizedAlways
            case .whenInUse: return .authorizedWhenInUse
            }
        }
    }
    
    public static let shared = DSSLocationManager()
    private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    internal var currentDirectionsRequests: [MKDirections] = []
    
    private let locationManager = CLLocationManager()
    private let geocoder: CLGeocoder = CLGeocoder()
    
    public var desiredAccuracy: CLLocationAccuracy {
        get { locationManager.desiredAccuracy }
        set { locationManager.desiredAccuracy = newValue }
    }
    
    private var authorizationDispatchGroup: DispatchGroup?
    private var requestDispatchGroup: DispatchGroup?
    private var backgroundRequestDispatchGroup: DispatchGroup?
    
    private var requestQueues: [DispatchGroup?] {
        [requestDispatchGroup, backgroundRequestDispatchGroup]
    }
    
    private var locationResult: Result<CLLocation, Error> = .failure(NSError())
    
    public var allowsBackgroundLocationUpdates: Bool {
        get { locationManager.allowsBackgroundLocationUpdates }
        set { locationManager.allowsBackgroundLocationUpdates = newValue }
    }
    
    public var pausesLocationUpdatesAutomatically: Bool {
        get { locationManager.pausesLocationUpdatesAutomatically }
        set { locationManager.pausesLocationUpdatesAutomatically = newValue }
    }
    
    public var activityType: CLActivityType {
        get { locationManager.activityType }
        set { locationManager.activityType = newValue }
    }
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func startUpdatingSignificantLocationChanges() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    public func stopUpdatingSignificantLocationChanges() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    public func checkAuthorizationStatus(for statuses: CLAuthorizationStatus...) -> Bool {
        statuses.contains(CLLocationManager.authorizationStatus())
    }
    
    public func requestWhenInUseAuthorization(completion: @escaping (CLAuthorizationStatus) -> Void = { _ in }) {
        authorizationDispatchGroup = .init()
        authorizationDispatchGroup?.enter()
        
        locationManager.requestWhenInUseAuthorization()
        authorizationDispatchGroup?.notify(queue: .global()) { [weak self] in
            guard let self = self else { return }
            completion(self.authorizationStatus)
        }
    }
    
    public func requestAlwaysAuthorization(
        completion: @escaping (CLAuthorizationStatus) -> Void = { _ in }
    ) {
        authorizationDispatchGroup = .init()
        authorizationDispatchGroup?.enter()
        
        locationManager.requestAlwaysAuthorization()
        authorizationDispatchGroup?.notify(queue: .global()) { [weak self] in
            guard let self = self else { return }
            completion(self.authorizationStatus)
        }
    }
    
    public func requestLocation(
        type: AccessType, source: LocationRequestSource,
        completion: @escaping (Result<CLLocation, Error>) -> Void
    ) {
        guard checkAuthorizationStatus(for: type.status) else {
            guard authorizationDispatchGroup == nil else { return }
            switch type {
            case .always:
                requestAlwaysAuthorization { [weak self] status in
                    guard let self = self,
                          status == .authorizedAlways
                    else { return completion(.failure(DSSLocationError.location)) }
                    self.requestLocation(type: type, source: source, completion: completion)
                }
            case .whenInUse:
                requestWhenInUseAuthorization { [weak self] status in
                    guard let self = self, status == .authorizedWhenInUse else {
                        return completion(.failure(DSSLocationError.location))
                    }
                    self.requestLocation(type: type, source: source, completion: completion)
                }
            }
            return
        }
        
        if let location = locationManager.location {
            return completion(.success(location))
        }
        
        switch source {
        case .default:
            guard requestDispatchGroup == .none else { return completion(.failure(DSSLocationError.busy)) }
            requestDispatchGroup = .init()
            requestDispatchGroup?.enter()
            locationManager.requestLocation()
            requestDispatchGroup?.notify(queue: .global(), execute: { completion(self.locationResult) })
        case .background:
            guard backgroundRequestDispatchGroup == .none else { return completion(.failure(DSSLocationError.busy)) }
            backgroundRequestDispatchGroup = .init()
            backgroundRequestDispatchGroup?.enter()
            locationManager.requestLocation()
            backgroundRequestDispatchGroup?.notify(queue: .global(), execute: { completion(self.locationResult) })
        }
    }
        
    public func currentAddress(completion: @escaping (Result<CLPlacemark, DSSLocationError>) -> Void) {
        let handler: (Result<[CLPlacemark], DSSLocationError>) -> Void = { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let placemarks):
                guard let placemark = placemarks.first else { return completion(.failure(.location)) }
                completion(.success(placemark))
            }
        }
        
        requestLocation(type: .whenInUse, source: .default) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let location):
                self.fetchAddress(location: location, completion: handler)
            case .failure(let error):
                completion(.failure(.internal(error: error)))
            }
        }        
    }
    
    public func fetchAddress(location: CLLocation, completion: @escaping (Result<[CLPlacemark], DSSLocationError>) -> Void) {
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                return DispatchQueue.main.async { completion(.failure(.internal(error: error))) }
            }
            guard let placemarks = placemarks else {
                return DispatchQueue.main.async { completion(.failure(.unwrap(variable: "[Placemarks]"))) }
            }
            guard !placemarks.isEmpty else {
                return DispatchQueue.main.async { completion(.failure(.empty(field: "[Placemarks]"))) }
            }
                       
            DispatchQueue.main.async { completion(.success(placemarks)) }
        }
    }
    
    public func directions(
        origin: MKPlacemark,
        destination: MKPlacemark,
        completion: @escaping (Result<MKRoute, DSSLocationError>) -> Void
    ) {
        let request = directionRequest(origin: origin, destination: destination)
        let directions = MKDirections(request: request)
        cleanDirectionsRequests(directions: directions)
        
        directions.calculate { (response, error) in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(.internal(error: error))) }
                return
            }
            guard let routes = response?.routes else {
                DispatchQueue.main.async { completion(.failure(.unwrap(variable: "[MKRoute]"))) }
                return
            }
            let filterredRoutes = routes.sorted(by: \.distance)
            guard let route = filterredRoutes.first else {
                DispatchQueue.main.async { completion(.failure(.route(route: "No routes available"))) }
                return
            }
            DispatchQueue.main.async { completion(.success(route)) }
        }
    }
    
    public func fetchLocals(
        address searchCompletion: MKLocalSearchCompletion,
        completion: @escaping (Result<[MKMapItem], DSSLocationError>) -> Void
    ) {
        let search = MKLocalSearch(request: .init(completion: searchCompletion))
        
        search.start { response, error in
            if let error = error {
                return DispatchQueue.main.async { completion(.failure(.internal(error: error))) }
            }
            guard let response = response else {
                return DispatchQueue.main.async {
                    completion(.failure(.unwrap(variable: "response: MKLocalSearch.Response")))
                }
            }
            
            DispatchQueue.main.async { completion(.success(response.mapItems)) }
        }
    }
    
    public func startMonitoring(for region: CLRegion) {
        locationManager.startMonitoring(for: region)
    }
    
    public func stopMonitoring(for region: CLRegion) {
        locationManager.stopMonitoring(for: region)
    }
    
    private func cleanDirectionsRequests(directions: MKDirections) {
        currentDirectionsRequests.forEach({ $0.cancel() })
        currentDirectionsRequests.append(directions)
    }
    
    private func directionRequest(origin: MKPlacemark, destination: MKPlacemark) -> MKDirections.Request {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: origin)
        request.destination = MKMapItem(placemark: MKPlacemark(placemark: destination))
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
}

extension DSSLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        post(notification: LocationNotification.didUpdateLocation, object: locations.first)
        
        guard let location = locations.first else {
            requestDispatchGroup?.leave()
            requestDispatchGroup = nil
            backgroundRequestDispatchGroup?.leave()
            backgroundRequestDispatchGroup = nil
            return
        }
        
        locationResult = .success(location)
        requestDispatchGroup?.leave()
        requestDispatchGroup = nil
        backgroundRequestDispatchGroup?.leave()
        backgroundRequestDispatchGroup = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationResult = .failure(error)
        requestDispatchGroup?.leave()
        requestDispatchGroup = nil
        backgroundRequestDispatchGroup?.leave()
        backgroundRequestDispatchGroup = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        authorizationStatus = status
        authorizationDispatchGroup?.leave()
        authorizationDispatchGroup = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        post(notification: LocationNotification.didExitRegion, object: region)
    }
}
