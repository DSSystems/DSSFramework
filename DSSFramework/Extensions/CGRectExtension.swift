//
//  CGRectExtension.swift
//  DSSFramework
//
//  Created by David on 18/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import CoreGraphics

public func +(lhs: CGRect, rhs: (x: CGFloat, y: CGFloat)) -> CGRect {
    return .init(x: lhs.minX - rhs.x, y: lhs.minY - rhs.y, width: lhs.width - rhs.x, height: lhs.height - rhs.y)
}

public extension CGRect {
    
    /// Returns height / width
    var aspectRatio: CGFloat {
        return height / width
    }
}

extension CGSize: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Float
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(width: CGFloat(value), height: CGFloat(value))
    }
}

extension CGSize: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(width: value, height: value)
    }
}
