//
//  UIEdgeInsetsExtension.swift
//  DSSFramework
//
//  Created by David on 30/09/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    static func equallySpaced(with paddig: CGFloat) -> Self {
        .init(top: paddig, left: paddig, bottom: paddig, right: paddig)
    }
    
    static func equallySpaced(horizontal hPadding: CGFloat, vertical vPadding: CGFloat) -> Self {
        .init(top: vPadding, left: hPadding, bottom: vPadding, right: hPadding)
    }
}
