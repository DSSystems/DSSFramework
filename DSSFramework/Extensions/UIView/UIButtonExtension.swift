//
//  UIButtonExtension.swift
//  DSSFramework
//
//  Created by David on 01/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UIButton {
    convenience init(title: String, font: UIFont? = nil, cornerRadius: CGFloat = 0) {
        self.init(type: .system)
        
        if cornerRadius != 0 { layer.cornerRadius = cornerRadius }
        
        setTitle(title, for: .normal)
        
        if let font = font { titleLabel?.font = font }
    }
}
