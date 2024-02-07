//
//  FloatExtension.swift
//  DSSFramework
//
//  Created by David on 15/03/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation
import CoreGraphics

public extension Float {
    func round(to places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

public extension CGFloat {
    func round(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return (self * divisor).rounded() / divisor
    }
}
