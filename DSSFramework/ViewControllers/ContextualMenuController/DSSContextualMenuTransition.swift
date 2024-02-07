//
//  DSSContextualMenuTransition.swift
//  DSSFramework
//
//  Created by David on 29/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public class DSSContextualMenuTransition: DSSViewControllerTransition {
    static public let `default` = DSSContextualMenuTransition(transitionDuration: 0.15)
    
    override public func transitionHandler(from fromViewController: UIViewController,
                                           to toViewController: UIViewController,
                                           containerView: UIView,
                                           transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
            containerView.addSubview(toViewController.view)
            
            toViewController.view.frame = containerView.frame
            toViewController.view.transform = .init(scaleX: 1.2, y: 1)
            toViewController.view.alpha = 0
        }
        
        let presentAnimation = {
            toViewController.view.transform = .identity
            toViewController.view.alpha = 1
        }
        
        let dismissAnimation = {
            fromViewController.view.transform = .init(scaleX: 1.2, y: 1)
            fromViewController.view.alpha = 0
        }
        
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        animate(duration: duration, presentAnimation: presentAnimation, dismissAnimation: dismissAnimation) { _ in
            transitionContext.completeTransition(!isCancelled)
        }
    }
}
