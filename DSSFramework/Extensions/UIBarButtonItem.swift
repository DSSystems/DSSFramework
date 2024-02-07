//
//  UIBarButtonItem.swift
//  DSSFramework
//
//  Created by David on 11/04/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit.UIBarButtonItem

public extension UIBarButtonItem {
    class func newFlexibleSpace() -> UIBarButtonItem {
        return .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    class func newActivityIndicator(style: UIActivityIndicatorView.Style) -> UIBarButtonItem {
        let indicatorView = UIActivityIndicatorView(style: style)
        indicatorView.startAnimating()
        return .init(customView: indicatorView)
    }
}
