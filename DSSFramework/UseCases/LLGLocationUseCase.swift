//
//  LLGLocationUseCase.swift
//  DSSFramework
//
//  Created by David on 27/12/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import CoreLocation

open class LLGLocationManager: NSObject {
    private let locatinManager = CLLocationManager()
    
    public override init() {
        super.init()
    }
    
    public func checkAuthorizationStatus(for statuses: CLAuthorizationStatus...) -> Bool {
        statuses.contains(CLLocationManager.authorizationStatus())
    }
    
    public func requestWhenInUseAuthorization(completion: @escaping (Bool) -> Void) {
        locatinManager.requestWhenInUseAuthorization()
    }
    
    public func requestAlwayAuthorization(completion: @escaping (Bool) -> Void) {
        locatinManager.requestAlwaysAuthorization()
    }
}
