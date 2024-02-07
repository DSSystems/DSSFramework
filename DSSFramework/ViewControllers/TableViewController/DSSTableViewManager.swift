//
//  DSSTableViewManager.swift
//  DSSFramework
//
//  Created by David on 30/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSTableViewManager: UITableViewDelegate, UITableViewDataSource {
    var reusableCells: [CellId: CellClass] { get }
    var reusableHeaders: [CellId: CellClass] { get }
    var reusableFooters: [CellId: CellClass] { get }
    
    var weakTableView: WeakRef<UITableView>! { get set }
    
    func viewWillAppear(viewController: UIViewController?)
    func viewDidAppear(viewController: UIViewController?)
    func setup(tableView: UITableView)
    func fetch(tableView: UITableView)
}

public extension DSSTableViewManager {
    func viewWillAppear(viewController: UIViewController?) { }
    
    func viewDidAppear(viewController: UIViewController?) { }
    
    func setup(tableView: UITableView) { }
    
    func fetch(tableView: UITableView) { }
}

public extension DSSTableViewManager where Self: NSObject {
    var reusableCells: [CellId: CellClass] { return [:] }
    var reusableHeaders: [CellId: CellClass] { return [:] }
    var reusableFooters: [CellId: CellClass] { return [:] }
    
    var tableView: UITableView? {
        guard let tableView = weakTableView?.object else { return nil }
        return tableView
    }
    
    func registerCells(tableView: UITableView) {
        reusableCells.forEach { tableView.register($0.value, forCellReuseIdentifier: $0.key) }
        reusableHeaders.forEach { tableView.register($0.value, forHeaderFooterViewReuseIdentifier: $0.key) }
        reusableFooters.forEach { tableView.register($0.value, forHeaderFooterViewReuseIdentifier: $0.key) }
    }
    
    func reusableCell<T: UITableViewCell & DSSIdentifiable>(tableView: UITableView, for indexPath: IndexPath) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("\(#function): Failed to dequeue cell for \(NSStringFromClass(T.self)).")
        }
        return cell
    }
    
    func reusableHeaderFooter<T: UIView & DSSIdentifiable>(tableView: UITableView) -> T {
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("\(#function): Failed to dequeue cell for \(NSStringFromClass(T.self)).")
        }
        return cell
    }
}
