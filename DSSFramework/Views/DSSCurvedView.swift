//
//  DSSCurvedView.swift
//  DSSFramework
//
//  Created by David on 08/12/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

open class DSSCurvedView: UIView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2
    }
}

open class DSSCardView: UIView {
    public let corners: UIRectCorner
    public let radius: CGFloat
    
    public init(frame: CGRect = .zero, corners: UIRectCorner, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
        
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: corners, radius: radius)
    }
}
