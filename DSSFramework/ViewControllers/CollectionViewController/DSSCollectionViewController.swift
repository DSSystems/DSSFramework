//
//  DSSCollectionViewController.swift
//  DSSFramework
//
//  Created by David on 05/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSCollectionViewController<T: DSSCollectionViewManager>: UICollectionViewController {
    // MARK: - Properties
    
    public let manager: T
    
    // MARK: - Init
    
    public init(manager: T) {
        self.manager = manager
        super.init(collectionViewLayout: manager.layout)
        self.manager.weakCollectionView = WeakRef(collectionView)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = manager
        collectionView.dataSource = manager
        
        manager.setup(collectionView: collectionView)
        manager.registerCells(collectionView: collectionView)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        manager.viewWillAppear(viewController: self)
        
        manager.fetch(collectionView: collectionView)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.viewDidAppear(viewController: self)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.viewWillDisappear(viewController: self)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        manager.viewDidDisappear(viewController: self)
    }
}
