//
//  DSSViewControllerTransitioner.swift
//  DSSFramework
//
//  Created by David on 08/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSViewControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - Properties
    
    open var isPresenting: Bool = false
    
    open var transitionDuration: TimeInterval
        
    open var dimmingViewBackgroundColor: UIColor { .black }
    
    // MARK: - Init
    
    public init(transitionDuration: TimeInterval) {
        self.transitionDuration = transitionDuration
        super.init()
    }
    
    // MARK: - Handlers
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from)
        else { return }
        
        let containerView = transitionContext.containerView
        
        transitionHandler(
            from: fromViewController,
            to: toViewController,
            containerView: containerView,
            transitionContext: transitionContext
        )
    }
    
    open func transitionHandler(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        containerView: UIView,
        transitionContext: UIViewControllerContextTransitioning
    ) {
        fatalError("You have to override this method!")
    }
    
    public func animate(
        duration: TimeInterval,
        damping: CGFloat = 0,
        presentAnimation: @escaping () -> Void,
        dismissAnimation: @escaping () -> Void,
        completion: @escaping (Bool) -> Void
    ) {
        
        let animations = {
            self.isPresenting ? presentAnimation() : dismissAnimation()
        }
        
        guard damping > 0 else {
            return UIView.animate(
                withDuration: duration,
                delay: 0,
                options: .curveEaseOut,
                animations: animations,
                completion: completion
            )
        }
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: 0,
            options: .curveEaseOut,
            animations: animations,
            completion: completion
        )
    }
    
    public func present() -> Self {
        isPresenting = true
        return self
    }
    
    public func dismiss() -> Self {
        isPresenting = false
        return self
    }
}
