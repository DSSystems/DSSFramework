//
//  DSSCountryManager.swift
//  DSSFramework
//
//  Created by David on 30/01/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation
import CoreLocation

final public class DSSCountryManager: NSObject {
    public static let `default` = DSSCountryManager()
    
    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
//        manager.desiredAccuracy = 10000
        return manager
    }()
    
    private let geocoder = CLGeocoder()
    private var dispatchGroup: DispatchGroup?
    
    private var location: CLLocation?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func getCountryNames() -> [String] {
        var countries: [String] = []
        var languageCode: String = "en"
        
        if let code = Locale.current.languageCode {
            languageCode = code
        }
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: languageCode).displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        
        return countries
    }
    
    public func currentCountryCode(_ completion: @escaping (String?) -> Void) {
        dispatchGroup = DispatchGroup()
//        dispatchGroup?.enter()
//        locationManager.requestLocation()
        
        dispatchGroup?.notify(queue: .main, execute: {
            guard let location = self.location else {
                completion(nil)
                return
            }
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first else {
                    completion(nil)
                    return
                }
                
                completion(placemark.isoCountryCode)
            }
        })
    }
    
    public var localCountryName: String {
        guard let regionCode = Locale.current.regionCode, let localCountryName = Locale.current.localizedString(forRegionCode: regionCode) else {
            return Locale.current.localizedString(forRegionCode: "US")!
        }
        return localCountryName
    }
    
    public func getCodes() -> [String] {
        return NSLocale.isoCountryCodes as [String]
    }
}

extension DSSCountryManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
        dispatchGroup?.leave()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(description): \(error.localizedDescription)")
        dispatchGroup?.leave()
    }
}
