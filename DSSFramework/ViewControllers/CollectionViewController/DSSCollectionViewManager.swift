//
//  DSSCollectionViewManager.swift
//  DSSFramework
//
//  Created by David on 01/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public typealias CellId = String
public typealias CellClass = AnyClass

public enum DSSFetchStatus: Equatable {
    case fetching, message(title: String?, text: String), done
}

public protocol DSSCollectionViewManager: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout where Self: NSObject {
    var layout: UICollectionViewLayout { get }
    var reusableCells: [CellId: CellClass] { get }
    var reusableHeaders: [CellId: CellClass] { get }
    var reusableFooters: [CellId: CellClass] { get }
    
    var weakCollectionView: WeakRef<UICollectionView>! { get set }
    
    func viewWillAppear(viewController: UIViewController?)
    func viewDidAppear(viewController: UIViewController?)
    func viewWillDisappear(viewController: UIViewController?)
    func viewDidDisappear(viewController: UIViewController?)
    
    /// This method is called inside UIViewController.
    /// - parameter collectionView The collection view to set it up
    func setup(collectionView: UICollectionView)
    func fetch(collectionView: UICollectionView)
}

public extension DSSCollectionViewManager where Self: NSObject {
    var reusableCells: [CellId: CellClass] { return [:] }
    var reusableHeaders: [CellId: CellClass] { return [:] }
    var reusableFooters: [CellId: CellClass] { return [:] }
    
    var headerKind: String { UICollectionView.elementKindSectionHeader }
    var footerKind: String { UICollectionView.elementKindSectionFooter }
    
    var collectionView: UICollectionView? {
        guard let collectionView = weakCollectionView?.object else { return nil }
        return collectionView
    }

    func viewWillAppear(viewController: UIViewController?) { }
    
    func viewDidAppear(viewController: UIViewController?) { }
    
    func viewWillDisappear(viewController: UIViewController?) { }
    
    func viewDidDisappear(viewController: UIViewController?) { }
    
    func setup(collectionView: UICollectionView) { }
    
    func fetch(collectionView: UICollectionView) { }
        
    func registerCells(collectionView: UICollectionView) {        
        reusableCells.forEach {
            collectionView.register($0.value, forCellWithReuseIdentifier: $0.key)
        }
        
        reusableHeaders.forEach {
            collectionView.register(
                $0.value,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: $0.key
            )
        }
        
        reusableFooters.forEach {
            collectionView.register(
                $0.value,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: $0.key
            )
        }
    }
    
    func reusableCell<T: UICollectionViewCell & DSSIdentifiable>(collectionView: UICollectionView, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("\(#function): Failed to dequeue cell for \(NSStringFromClass(T.self)).")
        }
        return cell
    }
    
    func reusableHeader<T: UICollectionReusableView & DSSIdentifiable>(collectionView: UICollectionView, for indexPath: IndexPath) -> T {
        let kind = UICollectionView.elementKindSectionHeader
        let id = T.identifier
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? T else {
            fatalError("\(#function): Failed to dequeue cell for \(NSStringFromClass(T.self)).")
        }
        return cell
    }
    
    func reusableFooter<T: UICollectionReusableView & DSSIdentifiable>(collectionView: UICollectionView, for indexPath: IndexPath) -> T {
        let kind = UICollectionView.elementKindSectionFooter
        let id = T.identifier
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? T else {
            fatalError("\(#function): Failed to dequeue cell for \(NSStringFromClass(T.self)).")
        }
        return cell
    }
    
    func createCollectionView(frame: CGRect = .zero) -> UICollectionView {
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        registerCells(collectionView: collectionView)
        setup(collectionView: collectionView)
        
        return collectionView
    }
}
