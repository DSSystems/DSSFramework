//
//  CGFloatExtension.swift
//  DSSFramework
//
//  Created by David on 18/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import CoreGraphics

public extension CGFloat {
    static var normalRandom: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
