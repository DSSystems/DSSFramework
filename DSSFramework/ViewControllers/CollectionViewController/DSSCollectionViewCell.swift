//
//  DSSCollectionViewCell.swift
//  DSSFramework
//
//  Created by David on 05/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSCollectionViewCell: UICollectionViewCell, DSSIdentifiable {
    // MARK: - Properties
        
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    open func setup() {
        fatalError("You must override this method!")
    }
}
