//
//  DSSColor.swift
//  DSSFramework
//
//  Created by David on 09/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public struct DSSColor {
    // MARK: - Properties
    
    public let light: UIColor
    public let dark: UIColor
    
    // MARK: - Init
    
    public init(light: UIColor, dark: UIColor) {
        self.light = light
        self.dark = dark
    }
    
    init(_ fixedColor: UIColor) {
        self.light = fixedColor
        self.dark = fixedColor
    }
    
    public static func fixedColor(_ color: UIColor) -> DSSColor {
        return .init(color)
    }
    
    public static func fixedColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 100) -> DSSColor {
        return fixedColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a / 100)
    }
    
    public static func fixedColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> DSSColor {
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return .init(color)
    }
    
    public static func fullColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 100,
                                 darkColorFactor: CGFloat = 1 / 2) -> DSSColor {
        return fullColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a / 100, darkColorFactor: darkColorFactor)
    }
    
    public static func fullColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1,
                                 darkColorFactor: CGFloat = 1 / 2) -> DSSColor {
        let light = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        let dark = UIColor(red: red * darkColorFactor,
                           green: green * darkColorFactor,
                           blue: blue * darkColorFactor,
                           alpha: alpha)
        return .init(light: light, dark: dark)
    }
}
