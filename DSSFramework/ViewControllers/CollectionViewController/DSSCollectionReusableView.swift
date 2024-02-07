//
//  DSSCollectionReusableView.swift
//  DSSFramework
//
//  Created by David on 09/10/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

open class DSSCollectionReusableView: UICollectionReusableView & DSSIdentifiable {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        fatalError("You shuld override this method!")
    }
}
