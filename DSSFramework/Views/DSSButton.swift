//
//  DSSButton.swift
//  DSSFramework
//
//  Created by David on 01/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSButton: UIButton {
    
    // MARK: - Init
    
    public convenience init(title: String, cornerRadius: CGFloat = 0) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        
        if cornerRadius > 0 { layer.cornerRadius = cornerRadius }
        
        setup()
    }
    
    public convenience init(imageName: String, cornerRadius: CGFloat = 0) {
        self.init(type: .system)
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        
        if cornerRadius > 0 { layer.cornerRadius = cornerRadius }
        
        setup()
    }
    
    public convenience init() {
        self.init(type: .system)
        
        setup()
    }
    
    // MARK: - Handlers
    
    open func setup() { }
}
