//
//  UIApplicationExtension.swift
//  DSSFramework
//
//  Created by David on 01/10/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

public extension UIApplication {
    func topViewController() -> UIViewController? {
        guard let keyWindow = windows.filter(\.isKeyWindow).first else { return nil }
        
        guard var topController = keyWindow.rootViewController else { return nil }
        
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        return topController
    }
}
