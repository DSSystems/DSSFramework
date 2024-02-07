//
//  DSSStretchyCollectionViewLayout.swift
//  DSSFramework
//
//  Created by David on 14/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

/// This class is not finished yet
final public class DSSStretchyCollectionViewLayout: UICollectionViewFlowLayout {
    private var initialBounds: CGRect? = nil
        
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach { attributes in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                guard let collectionView = collectionView else { return }
                let contentOffsetY = collectionView.contentOffset.y
                let height = attributes.frame.height - contentOffsetY
                if initialBounds == nil { initialBounds = collectionView.bounds }
                
                guard contentOffsetY < (initialBounds?.minY ?? 0) else { return }
                
                let frame = CGRect(x: attributes.frame.minX,
                                   y: -(initialBounds?.minY ?? 0) + attributes.frame.minY + contentOffsetY,
                                   width: attributes.frame.width,
                                   height: height)
                
                attributes.frame = frame
            }
        }
        
        return layoutAttributes
    }
}

//final public class DSSStickyHeadersCollectionViewLayout: UICollectionViewFlowLayout {
//    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
//
//    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
//
//        // Helpers
//        let sectionsToAdd = NSMutableIndexSet()
//        var newLayoutAttributes: [UICollectionViewLayoutAttributes] = []
//
//        layoutAttributes.forEach {
//            if $0.representedElementCategory == .cell {
//                newLayoutAttributes.append($0)
//
//                sectionsToAdd.add($0.indexPath.section)
//            } else if $0.representedElementCategory == .supplementaryView {
//                sectionsToAdd.add($0.indexPath.section)
//            }
//        }
//
//        sectionsToAdd.forEach {
//            let indexPath = IndexPath(item: 0, section: $0)
//            let kind = UICollectionView.elementKindSectionHeader
//            if let sectionAttributes = layoutAttributesForSupplementaryView(ofKind: kind, at: indexPath) {
//                newLayoutAttributes.append(sectionAttributes)
//            }
//        }
//
//        return newLayoutAttributes
//    }
//
//    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
//        guard let boundaries = boundaries(forSection: indexPath.section) else { return nil }
//        guard let collectionView = collectionView else { return nil }
//
//        // Helpers
//        let contentOffsetY = collectionView.contentOffset.y
//        var frameForSupplementaryView = layoutAttributes.frame
//
//        let minimum = boundaries.minimum - frameForSupplementaryView.height
//        let maximum = boundaries.maximum - frameForSupplementaryView.height
//
//        if contentOffsetY < minimum {
//            frameForSupplementaryView.origin.y = minimum
//        } else if contentOffsetY > maximum {
//            frameForSupplementaryView.origin.y = maximum
//        } else {
//            frameForSupplementaryView.origin.y = contentOffsetY
//        }
//
//        layoutAttributes.frame = frameForSupplementaryView
//
//        return layoutAttributes
//    }
//
//    private func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
//        // Helpers
//        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
//
//        // Exit Early
//        guard let collectionView = collectionView else { return result }
//
//        // Fetch Number of Items for Section
//        let numberOfItems = collectionView.numberOfItems(inSection: section)
//
//        // Exit Early
//        guard numberOfItems > 0 else { return result }
//
//        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
//           let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
//            result.minimum = firstItem.frame.minY
//            result.maximum = lastItem.frame.maxY
//
//            // Take Header Size Into Account
//            result.minimum -= headerReferenceSize.height
//            result.maximum -= headerReferenceSize.height
//
//            // Take Section Inset Into Account
//            result.minimum -= sectionInset.top
//            result.maximum += (sectionInset.top + sectionInset.bottom)
//        }
//
//        return result
//    }
//}
