//
//  DSSSplashTransition.swift
//  DSSFramework
//
//  Created by David on 08/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSSplashTransition: DSSViewControllerTransition {

    // MARK: - Properties

    public static let `default`: DSSSplashTransition = .init(transitionDuration: 0.3)

    // MARK: - Handlers

    open override func transitionHandler(from fromViewController: UIViewController,
                                         to toViewController: UIViewController,
                                         containerView: UIView,
                                         transitionContext: UIViewControllerContextTransitioning) {

        if isPresenting {
            // Add dimming view
            // Add UIViewController to conteiner
            containerView.addSubview(toViewController.view)

            // Initial frame off the screen
//            toViewController.view.frame = .init(x: 0, y: 0, width: finalWidth, height: finalHeight)
            toViewController.view.transform = .init(scaleX: 0.01, y: 0.01)
            toViewController.view.alpha = 0
        }

        // Animate on screen
        let present = {
            toViewController.view.transform = .identity
            toViewController.view.alpha = 1
        }

        // Animate back off screen
        let dismiss = {
            fromViewController.view.transform = .init(scaleX: 0.01, y: 0.01)
            fromViewController.view.alpha = 0
        }

        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        animate(duration: duration, presentAnimation: present, dismissAnimation: dismiss) { _ in
            transitionContext.completeTransition(!isCancelled)
        }
    }
}
