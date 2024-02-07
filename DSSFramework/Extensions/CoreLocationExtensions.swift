//
//  CLLocationExtension.swift
//  DSSFramework
//
//  Created by David on 11/11/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import CoreLocation

public extension CLLocation {
    convenience init(_ coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

public extension CLPlacemark {
    var fullDescription: String {
        [thoroughfare, subThoroughfare, subLocality, locality].compactMap().joined(separator: " ")
    }
    
    var shortDescription: String {
        [thoroughfare, subThoroughfare/*, locality*/].compactMap().joined(separator: ", ")
    }
    
    var titleDescription: String {
        [thoroughfare, subThoroughfare].compactMap().joined(separator: ", ")
    }
    
    var subtitleDescription: String {
        [subLocality, locality].compactMap().joined(separator: ", ")
    }
}
