//
//  DSSCoordinatorController.swift
//  DSSFramework
//
//  Created by David on 16/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public enum DSSCoordinatorControllerStatus {
    case starting, active, message(text: String, showsActionbutton: Bool)
}

@objc public protocol DSSCoordinatorController: UIViewControllerTransitioningDelegate where Self: UIViewController {
    var logoImageView: UIImageView { get }
    var activityIndicatorView: UIActivityIndicatorView { get }
    var messageLabel: UILabel { get }
    var actionButton: UIButton { get }
        
    @objc optional func handleSplashAction(button: UIButton)
}

public extension DSSCoordinatorController {
    func setupPresentationViews() {
        view.addSubview(logoImageView)
        view.addSubview(messageLabel)
        view.addSubview(actionButton)
        view.addSubview(activityIndicatorView)
        
        logoImageView.usesAutolayout()
        logoImageView.center(to: view)
        logoImageView.widthAnchor(view.widthAnchor, multiplier: 0.5)
        logoImageView.heightAnchor(logoImageView.widthAnchor, multiplier: 9 / 16)
        
        activityIndicatorView.usesAutolayout()
        activityIndicatorView.anchor(top: logoImageView.bottomAnchor, padding: 16)
        activityIndicatorView.centerHorizontally(to: view)
        
        messageLabel.usesAutolayout()
        messageLabel.anchor(top: logoImageView.bottomAnchor, padding: 16)
        messageLabel.centerHorizontally(to: view)
        messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 8).isActive = true
        messageLabel.widthAnchor(view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        
        actionButton.usesAutolayout()
        actionButton.anchor(top: messageLabel.bottomAnchor, padding: 16)
        actionButton.centerHorizontally(to: view)
        
        actionButton.addTarget(self, action: #selector(handleSplashAction(button:)), for: .touchUpInside)
    }
    
    func update(status: DSSCoordinatorControllerStatus) {
        switch status {
        case .starting:
            activityIndicatorView.startAnimating()
            activityIndicatorView.isHidden = false
            messageLabel.isHidden = true
            logoImageView.isHidden = false
            logoImageView.transform = .identity
            actionButton.isHidden = true
        case .active:
            activityIndicatorView.stopAnimating()
            logoImageView.transform = .identity
            activityIndicatorView.isHidden = true
            messageLabel.isHidden = true
            actionButton.isHidden = true
            let animations: () -> Void = { self.logoImageView.transform = .init(scaleX: 0.01, y: 0.01) }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: animations) { _ in
                self.logoImageView.isHidden = true
            }
        case .message(let text, let showsActionbutton):
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
            messageLabel.isHidden = false
            logoImageView.isHidden = false
            logoImageView.transform = .identity
            messageLabel.text = text
            actionButton.isHidden = !showsActionbutton
        }
    }
}

public protocol DSSViewControllerTransitioningDelegate: UIViewControllerTransitioningDelegate {
    var currentTransition: DSSViewControllerTransition? { get set }
}

public extension DSSViewControllerTransitioningDelegate {
    var currentTransition: DSSViewControllerTransition? { return nil }    
}
