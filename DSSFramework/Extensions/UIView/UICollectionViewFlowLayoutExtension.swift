//
//  UICollectionViewFlowLayoutExtension.swift
//  DSSFramework
//
//  Created by David on 10/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UICollectionViewLayout {
    class func verticalFlowLayout(lineSpacing: CGFloat = 0, interitemSpacing: CGFloat = 0) -> UICollectionViewFlowLayout {
        .init(scrollDirection: .vertical, minimumLineSpacing: lineSpacing, minimumInteritemSpacing: interitemSpacing)
    }
    
    class func horizontalFlowLayout(lineSpacing: CGFloat = 0, interitemSpacing: CGFloat = 0) -> UICollectionViewFlowLayout {
        .init(scrollDirection: .horizontal, minimumLineSpacing: lineSpacing, minimumInteritemSpacing: interitemSpacing)
    }
}

public extension UICollectionViewFlowLayout {
    convenience init(scrollDirection: UICollectionView.ScrollDirection,
                     minimumLineSpacing: CGFloat,
                     minimumInteritemSpacing: CGFloat) {
        self.init()
        self.scrollDirection = scrollDirection
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
    
    convenience init(scrollDirection: UICollectionView.ScrollDirection,
                     minimumInteritemSpacing: CGFloat) {
        self.init()
        self.scrollDirection = scrollDirection
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
    
    convenience init(scrollDirection: UICollectionView.ScrollDirection,
                     minimumLineSpacing: CGFloat) {
        self.init()
        self.scrollDirection = scrollDirection
        self.minimumLineSpacing = minimumLineSpacing
    }
    
    convenience init(scrollDirection: UICollectionView.ScrollDirection) {
        self.init()
        self.scrollDirection = scrollDirection
    }
}
