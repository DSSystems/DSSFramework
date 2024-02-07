//
//  DSSLocationService.swift
//  DSSFramework
//
//  Created by David on 28/03/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

public enum DSSLocationError: Error {
    case location
    case busy
    case unwrap(variable: String)
    case empty(field: String)
    case route(route: String)
    case external(description: String)
    case locationNotAllowed
    case `internal`(error: Error)
    
    public var localizedDescription: String {
        switch self {
        case .location: return "LOCAL:UnableToRetrieveUsersLocation".localized
        case .busy: return "LOCAL:Busy".localized
        case .unwrap(let variable): return "\("LOCAL:FailedToUnwrapVariable".localized): \(variable)"
        case .empty(let field): return "\("LOCAL:FieldIsEmpty".localized): \(field)"
        case .route(let description): return "\("LOCAL:FailedToFetchRoutes".localized): \(description)"
        case .locationNotAllowed: return "LOCAL:LocationServicesNotAllowed".localized
        case .external(let description): return description
        case .internal(let error): return error.localizedDescription
        }
    }
}

public extension NotificationCenter {
    enum LocationNotification: String {
        case locationServiceAuthorization = "com.dssystems.notification.locationServiceDidChangeAuthorization"
        case serviceStatusDidChange = "com.dssystems.notification.serviceStatusDidChange"
        
        var name: Notification.Name {
            return .init(self.rawValue)
        }
    }
    
    func post(_ notificationType: LocationNotification, object: Any?) {
        self.post(name: notificationType.name, object: object)
    }
    
    func add(_ observer: Any, selector: Selector, notificationType: LocationNotification) {
        self.addObserver(observer, selector: selector, name: notificationType.name, object: nil)
    }
    
    func remove(_ observer: Any, _ notificationType: LocationNotification) {
        self.removeObserver(observer, name: notificationType.name, object: nil)
    }
}
