//
//  DSSShadowView.swift
//  DSSFramework
//
//  Created by David on 29/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSShadowView {
    var shadowColor: UIColor { get set }
    var shadowRadius: CGFloat { get }
    var shadowOffset: CGSize { get }
    
    func shadowPath(in rect: CGRect) -> CGPath
}
public extension DSSShadowView where Self: UIView {
    var shadowRadius: CGFloat { layer.cornerRadius }
    var shadowOffset: CGSize { .zero }
    
    func shadowPath(in rect: CGRect) -> CGPath { UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).cgPath }
    
    func setupShadow() {
        if #available(iOS 13.0, *) {
            layer.shadowColor = shadowColor.resolvedColor(with: traitCollection).cgColor
        } else {
            layer.shadowColor = shadowColor.cgColor
        }
        layer.shadowOpacity = 1
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        let rect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        layer.shadowPath = shadowPath(in: rect)
    }
}
