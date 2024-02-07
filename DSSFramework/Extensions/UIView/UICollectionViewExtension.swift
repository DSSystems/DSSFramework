//
//  UICollectionViewExtension.swift
//  DSSFramework
//
//  Created by David on 18/04/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit.UICollectionView

public extension UICollectionView {
    func register<Cell: DSSCollectionViewCell>(cell: Cell.Type) {
        register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
    }
}
