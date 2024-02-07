//
//  DSSTableViewController.swift
//  DSSFramework
//
//  Created by David on 01/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSTableViewController<T: DSSTableViewManager & NSObject>: UITableViewController {
    public typealias Manager = T
    
    // MARK: Properties
    
    public let manager: Manager
    
    // MARK: Init
    
    public init(manager: Manager) {
        self.manager = manager
        super.init(nibName: nil, bundle: Bundle.main)
        self.manager.weakTableView = WeakRef(tableView)
    }
    
    // MARK: - Handlers
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.registerCells(tableView: tableView)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.fetch(tableView: tableView)
        manager.viewDidAppear(viewController: self)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.delegate = manager
        tableView.dataSource = manager
        manager.setup(tableView: tableView)
        
        manager.viewWillAppear(viewController: self)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Handlers
}
