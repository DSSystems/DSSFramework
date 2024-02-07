//
//  CGSize.swift
//  DSSFramework
//
//  Created by David on 06/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import CoreGraphics
import UIKit

public extension CGSize {
    static func square(withArista arista: CGFloat) -> CGSize {
        return .init(width: arista, height: arista)
    }
}

extension CGSize {
    var area: CGFloat {
        return width * height
    }
    
    static func < (lhs: CGSize, rhs: CGSize) -> Bool {
        guard lhs.width < rhs.width else { return false }
        
        return lhs.height < rhs.height
    }
    
    static func <= (lhs: CGSize, rhs: CGSize) -> Bool {
        guard lhs.width <= rhs.width else { return false }
        
        return lhs.height <= rhs.height
    }
}

public extension CGSize {
    func with(insets: UIEdgeInsets) -> CGSize {
        return .init(width: width - insets.left - insets.right, height: height - insets.top - insets.bottom)
    }
}
