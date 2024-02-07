//
//  URLExtension.swift
//  DSSFramework
//
//  Created by David on 08/04/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit.UIApplication

public extension URL {
    
    /// Attempts to open the URL externally
    func open() {
        guard UIApplication.shared.canOpenURL(self) else { return }
        
        DispatchQueue.main.async {
            UIApplication.shared.open(self, options: [:], completionHandler: nil)
        }
    }
}
