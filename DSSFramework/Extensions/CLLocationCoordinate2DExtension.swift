//
//  CLLocationCoordinate2DExtension.swift
//  DSSFramework
//
//  Created by David on 05/03/21.
//  Copyright © 2021 DS_Systems. All rights reserved.
//

import MapKit

public extension CLLocationCoordinate2D {
    init?(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        self.init(latitude: latitude, longitude: longitude)
    }
    
    func openInMaps(name: String) {
        let placemark = MKPlacemark(coordinate: self, addressDictionary: nil)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: self),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: MKCoordinateSpan(latitudeDelta: 300, longitudeDelta: 300))
        ])
    }
}
