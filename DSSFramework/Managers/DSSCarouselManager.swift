//
//  DSSCarouselManager.swift
//  DSSFramework
//
//  Created by David on 17/04/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

open class DSSCarouselCell<Model>: DSSCollectionViewCell {
    open var item: Model?
    
    open override func setup() {
    }
}

open class DSSCarouselManager<Model, CarouselCell>: NSObject, DSSCollectionViewManager where CarouselCell: DSSCarouselCell<Model> {
    
    open var items: [Model] = []
    
    open var widthScale: CGFloat { return 0.75 }
    
    open var spacing: CGFloat { return 44 }
    
    public var weakCollectionView: WeakRef<UICollectionView>!
    
//    open var contentInset: UIEdgeInsets {
//        guard let collectionViewWidth = collectionView?.frame.size.width else { return .zero }
//        let padding = collectionViewWidth * (1 - widthScale) / 2
//        return .init(top: 0, left: padding, bottom: 0, right: padding)
//    }
    
    open var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout(scrollDirection: .horizontal)
        return layout
    }()
    
    /// When overriding this method do not forget to call *super.setup(collectionView:)*
    open func setup(collectionView: UICollectionView) {
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    open func fetch(collectionView: UICollectionView) {
    }
        
    /// When overriding this method do not forget to call *super.setup(collectionView:)*
    open func viewWillAppear(viewController: UIViewController?) {
//        self.collectionView?.contentInset = contentInset
    }
    
    open func viewDidAppear(viewController: UIViewController?) {
    }
        
    open var reusableCells: [CellId : CellClass] {
        return [CarouselCell.identifier: CarouselCell.self]
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        let collectionViewWidth = collectionView.frame.size.width
        let padding = rint(collectionViewWidth * (1 - widthScale) / 2)
        collectionView.contentInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CarouselCell = reusableCell(collectionView: collectionView, for: indexPath)
        cell.item = items[indexPath.item]
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width * widthScale
        let height = collectionView.frame.size.height - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom
        return .init(width: width, height: height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    private var indexOfCellBeforeDragging: Int = 0
    final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = Int(indexOfMajorCell(scrollView: scrollView))
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let width = collectionView?.frame.width else { return }
        let cellWidth = widthScale * width
        
        let swipeVelocityThreshold: CGFloat = 0.3
        
        let item = rint((scrollView.contentInset.left + targetContentOffset.pointee.x) / (cellWidth + spacing))
                
        let didUseSwipeToSkipCell = abs(velocity.x) > swipeVelocityThreshold
        
        guard didUseSwipeToSkipCell else {
            let offset = CGPoint(x: item * (cellWidth + spacing) - scrollView.contentInset.left,
                                 y: scrollView.contentInset.top)
            targetContentOffset.pointee = offset
            return
        }
        
        let snapToIndex = max(min(indexOfCellBeforeDragging + (velocity.x > 0 ? 1 : -1), items.count - 1), 0)
        targetContentOffset.pointee = .init(x: CGFloat(snapToIndex) * (cellWidth + self.spacing) - scrollView.contentInset.left, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
            scrollView.contentOffset = CGPoint(x: CGFloat(snapToIndex) * (cellWidth + self.spacing) - scrollView.contentInset.left, y: 0)
            scrollView.layoutIfNeeded()
        }, completion: nil)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    private func indexOfMajorCell(scrollView: UIScrollView) -> CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let cellWidth = widthScale * collectionView.frame.width
        return rint((scrollView.contentInset.left + scrollView.contentOffset.x) / (cellWidth + spacing))
    }
}
