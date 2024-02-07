//
//  DSSIdentifiable.swift
//  DSSFramework
//
//  Created by David on 15/03/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit
import MapKit.MKAnnotationView

public protocol DSSIdentifiable {
}

public extension DSSIdentifiable where Self: AnyObject {
    static var identifier: String {
        return "\(NSStringFromClass(Self.self)).identifier"
    }
}

public extension DSSIdentifiable where Self: UIView {
    static var identifier: String {
        return "\(NSStringFromClass(Self.self)).identifier"
    }
}

public extension DSSIdentifiable where Self: MKAnnotationView {
    static var identifier: String {
        return "\(NSStringFromClass(Self.self)).identifier"
    }
}
