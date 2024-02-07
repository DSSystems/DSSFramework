//
//  DSSDynamicInterfaceStyle.swift
//  DSSFramework
//
//  Created by David on 09/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSDynamicInterfaceStyle {
    func setupDarkModeColors<Enviroment: DSSEnviroment>(_ enviroment: Enviroment.Type)
    func setupLightModeColors<Enviroment: DSSEnviroment>(_ enviroment: Enviroment.Type)
    
    func themeColorsDidChange(_ traitCollection: UITraitCollection)
}

public extension DSSDynamicInterfaceStyle {
    func themeColorsDidChange(_ traitCollection: UITraitCollection) { }
    
    func setupColors<Enviroment: DSSEnviroment>(_ traitCollection: UITraitCollection,
                                                enviroment: Enviroment.Type) {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .unspecified: break
            case .light: setupLightModeColors(enviroment)
            case .dark: setupDarkModeColors(enviroment)
            @unknown default: fatalError("Apple added a new case to UIUserInterfaceStyle")
            }
        } else {
            setupLightModeColors(enviroment)
        }
    }
}

public protocol DSSDynamicInterfaceStyleHandler: DSSDynamicInterfaceStyle {
    var themeTimingAnimation: TimeInterval { get }
}

public extension DSSDynamicInterfaceStyleHandler {
    func updateColors<Enviroment: DSSEnviroment>(_ traitCollection: UITraitCollection,
                                                 enviroment: Enviroment.Type,
                                                 animated: Bool = true) {
        if #available(iOS 12.0, *) {
            switch traitCollection.userInterfaceStyle {
            case .unspecified: break
            case .light:
                if animated {
                    UIView.animate(withDuration: themeTimingAnimation, animations: {
                        self.setupLightModeColors(enviroment)
                    }) { _ in
                        self.themeColorsDidChange(traitCollection)
                    }
                } else {
                    setupLightModeColors(enviroment)
                    themeColorsDidChange(traitCollection)
                }
            case .dark:
                if animated {
                    UIView.animate(withDuration: themeTimingAnimation, animations: {
                        self.setupDarkModeColors(enviroment)
                    }) { _ in
                        self.themeColorsDidChange(traitCollection)
                    }
                } else {
                    setupDarkModeColors(enviroment)
                    themeColorsDidChange(traitCollection)
                }
            @unknown default: fatalError("Apple implemented a new case to UIUserInterfaceStyle")
            }
        } else {
            setupLightModeColors(enviroment)
        }
    }
}
