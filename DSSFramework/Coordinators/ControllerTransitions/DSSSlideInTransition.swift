//
//  DSSSlideInTransition.swift
//  DSSFramework
//
//  Created by David on 08/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSSlideInTransition: DSSViewControllerTransition {
    // MARK: - Types
    
    public enum InitialPosition { case left, right }
    
    // MARK: - Properties
    
    public static let `default`: DSSSlideInTransition = .init(transitionDuration: 0.3)
    
    open var widthRatio: CGFloat = 0.8
    open var heightRatio: CGFloat = 1
    open var initialPosition: InitialPosition = .left
    
    open var dimmingView = UIView()
    
    private weak var presentedController: UIViewController?
    
    // MARK: - Handlers
    
    open override func transitionHandler(from fromViewController: UIViewController,
                                         to toViewController: UIViewController,
                                         containerView: UIView,
                                         transitionContext: UIViewControllerContextTransitioning) {
        
        let finalWidth = containerView.bounds.width * widthRatio
        let finalHeight = containerView.bounds.height * heightRatio
        
        if isPresenting {
            // Add dimming view
            dimmingView.backgroundColor = dimmingViewBackgroundColor
            dimmingView.alpha = 0
            containerView.addSubview(dimmingView)
            dimmingView.frame = containerView.bounds
            // Add UIViewController to conteiner
            containerView.addSubview(toViewController.view)
            
            // Initial frame off the screen
            let xPosition = initialPosition == .left ? -finalWidth : containerView.frame.size.width
            
            toViewController.view.frame = .init(x: xPosition, y: 0, width: finalWidth, height: finalHeight)
        }
        
        // Animate on screen
        let xTranslation = self.initialPosition == .left ? finalWidth : -finalWidth
        let transform = { [weak self] in
            guard let self = self else { return }
            self.dimmingView.alpha = 0.5
            
            toViewController.view.transform = .init(translationX: xTranslation, y: 0)
        }
        
        // Animate back off screen
        let identity = { [weak self] in
            guard let self = self else { return }
            self.dimmingView.alpha = 0
            fromViewController.view.transform = .identity
        }
        
        // Animation of the transition
        let duration = transitionDuration(using: transitionContext)
        let isCancelled = transitionContext.transitionWasCancelled
        animate(duration: duration, presentAnimation: transform, dismissAnimation: identity) { [weak self] _ in
            guard let self = self else { return }
            transitionContext.completeTransition(!isCancelled)
            self.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleDismiss)))
            self.presentedController = toViewController
        }
    }
    
    @objc private func handleDismiss() {
        self.presentedController?.dismiss(animated: true) { [weak self] in
            self?.presentedController = nil
        }
    }
}

