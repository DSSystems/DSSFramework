//
//  UIColorExtension.swift
//  DSSFramework
//
//  Created by David on 18/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UIColor {
    class var random: UIColor {
        return .init(red: .normalRandom,
                     green: .normalRandom,
                     blue: .normalRandom,
                     alpha: .normalRandom)
    }
    
    // MARK: - Init
    
    // A RBGA format initializer (r, g, b = (0-255) and a = 0-100)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 100) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a / 100)
    }
    
    // A dynamic RBGA format initializer (R, G, B = (0-255) and A = 0-100) and the l (d) prefix denotes the light (dark) value
    typealias RGBAColor = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    convenience init(lightRGBA light: RGBAColor, darkRGBA dark: RGBAColor) {
        if #available(iOS 13.0, *) {
            self.init { traitCollection -> UIColor in
                return traitCollection.userInterfaceStyle == .dark ?
                    .init(r: dark.r, g: dark.g, b: dark.b, a: dark.a) :
                    .init(r: light.r, g: light.g, b: light.b, a: light.a)
            }
        } else {
            self.init(r: light.r, g: light.g, b: light.b, a: light.a)
        }
    }
    
    class func autoDarkFromLight(rgba lightColor: RGBAColor) -> UIColor {
        let darkColor: RGBAColor = (r: (255 - lightColor.r) * lightColor.a / 100,
                                    g: (255 - lightColor.g) * lightColor.a / 100,
                                    b: (255 - lightColor.b) * lightColor.a / 100,
                                    a: lightColor.a)
        
        return .init(lightRGBA: lightColor, darkRGBA: darkColor)
    }
    
    class func autoDarkFrom(lightColor: UIColor) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        
        _ = lightColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let darkColor: UIColor = .init(red: (1 - red) * alpha,
                                       green: (1 - green) * alpha,
                                       blue: (1 - blue) * alpha,
                                       alpha: alpha)
        
        return .init(light: lightColor, dark: darkColor)
    }
    
    class func  autoLightFromDark(rgba darkColor: RGBAColor) -> UIColor {
        let lightColor: RGBAColor = (r: (255 - darkColor.r) * darkColor.a / 100,
                                     g: (255 - darkColor.g) * darkColor.a / 100,
                                     b: (255 - darkColor.b) * darkColor.a / 100,
                                     a: darkColor.a)
        
        return .init(lightRGBA: lightColor, darkRGBA: darkColor)
    }

    class func autoLightFrom(darkColor: UIColor) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        
        _ = darkColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let lightColor: UIColor = .init(red: (1 - red) * alpha,
                                        green: (1 - green) * alpha,
                                        blue: (1 - blue) * alpha,
                                        alpha: alpha)
        
        return .init(light: lightColor, dark: darkColor)
    }
    
    class func resolved(_ color: UIColor, with traitCollection: UITraitCollection) -> UIColor {
        if #available(iOS 13.0, *) {
            return color.resolvedColor(with: traitCollection)
        } else {
            return color
        }
    }
    
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            self.init { traitCollection -> UIColor in
                return traitCollection.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
    
    convenience init(hex: String) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) { scanner.scanLocation = 1 }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
