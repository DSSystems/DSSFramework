//
//  DSSImageFieldView.swift
//  DSSFramework
//
//  Created by David on 20/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSImageFieldDataProvider {
    // MARK: - Properties
    
    var placeholder: String? { get }
    
    var get: () -> UIImage? { get }
    
    var imageSelectorHandler: (UIImageView) -> Void { get }
}
