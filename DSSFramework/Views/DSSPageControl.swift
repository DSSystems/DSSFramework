//
//  DSSPageControl.swift
//  DSSFramework
//
//  Created by David on 12/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSPageControl: UIPageControl {
    var valueChangedHandler: ((Int) -> Void)?
    
    public func pageSelectorHandler(_ handler: @escaping (Int) -> Void) {
        valueChangedHandler = handler
        addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
    }
    
    @objc func handleValueChanged() {
        valueChangedHandler?(currentPage)
    }
}
