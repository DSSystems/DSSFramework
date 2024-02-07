//
//  DSSCoordinator.swift
//  DSSFramework
//
//  Created by David on 31/10/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSCoordinator: AnyObject {
//    var childCoordinators: [String: DSSCoordinator] { get set }
    
    // MARK: - Properties
    
    var rootViewController: DSSCoordinatorController & UIViewController { get set }
    
    // MARK: - init
    
    init(window: UIWindow?)
    
    // MARK: - Handlers
    
    func start()
}

public extension DSSCoordinator {
    var slideInTransition: DSSSlideInTransition { return .default }
    var splashTransition: DSSSplashTransition { return .default }
}
