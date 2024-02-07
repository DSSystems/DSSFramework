//
//  DSSCircularImageView.swift
//  DSSFramework
//
//  Created by David on 18/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSCircularImageView: UIImageView {
    
    // MARK: - Init
    
    public init(imageName name: String) {
        guard let image = UIImage(named: name) else {
            print("DSSCircularImageView: Image with name '\(name)' not found.")
            super.init(image: nil)
            return
        }
        super.init(image: image)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    public init(image: UIImage) {
        super.init(image: image)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    public init() {
        super.init(frame: .zero)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    // MARK: - Handlers
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2
    }
}
