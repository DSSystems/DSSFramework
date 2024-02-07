//
//  UIViewController.swift
//  DSSFramework
//
//  Created by David on 09/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UIViewController {
    var statusBarFrame: CGRect {
        UIApplication.shared.statusBarFrame
    }
    
    var navigationBarFrame: CGRect {
        navigationController?.navigationBar.frame ?? .zero
    }
    
    var bottomSafeAreaHeight: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    func safeDismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        guard let navigationController = navigationController else {
            dismiss(animated: flag, completion: completion)
            return
        }
        
        navigationController.popViewController(animated: flag)
        completion?()
    }
}
