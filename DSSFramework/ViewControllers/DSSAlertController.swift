//
//  DSSAlertController.swift
//  DSSFramework
//
//  Created by David on 03/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSAlertViewDelegate: AnyObject {
    func alertView(_ alertView: DSSAlertView, shouldDismissWithCompletion completion: @escaping () -> Void)
}

public extension DSSAlertViewDelegate {
    func alertView(_ alertView: DSSAlertView, shouldDismissWithCompletion completion: @escaping () -> Void) { }
}

public class DSSAlertAction {
    // MARK: - Types
    
    public enum Style {
        case `default`
        case regular
        case cancel
        case destructive
    }
    
    // MARK: - Properties
    
    public static func dismissAction(title: String, style: Style = .cancel) -> DSSAlertAction {
        .init(title: title, style: style) { alert in
            alert?.dismiss()
        }
    }
    
    public static func afterDismiss(title: String, style: Style, completion: @escaping (DSSAlertView?) -> Void) -> DSSAlertAction {
        DSSAlertAction(title: title, style: style) { alert in
            alert?.dismiss { completion(alert) }
        }
    }
        
    public let title: String
    
    public let style: Style
    
    let handler: (DSSAlertView?) -> Void
    
    fileprivate var alertView: DSSAlertView?
    
    // MARK: - Init
    
    public init(title: String, style: Style, handler: @escaping (DSSAlertView?) -> Void) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    // MARK: - Handlers
    
    @objc fileprivate func handleAction() { handler(alertView) }
}

open class DSSAlertView: UIView {
    // MARK: - Types
    
    public class var defaultButtonClass: AnyClass? {
        return nil
    }
    
    // MARK: - Properties
    
    public weak var delegate: DSSAlertViewDelegate?
    
    open var alertSize: CGSize { return .init(width: 100, height: 50) }
    
    open var actions: [DSSAlertAction] = []
    
    open var textFieldDataProviders: [DSSTextFieldDataProvider] = []
    
    // MARK: - Handlers
    
    open func setupLayout(superview: UIView) {
        fatalError("You have to override the method setupLayout(superview:) in \(NSStringFromClass(Self.self))")
    }
    
    /// Do not forget to call super.addAction:action after overriding this method
    open func addAction(_ action: DSSAlertAction) {
        action.alertView = self
        actions.append(action)
    }
    
    /// Do not forget to call super.addInput:dataProvider after overriding this method
    open func addInput(_ dataProvider: DSSTextFieldDataProvider) {
        textFieldDataProviders.append(dataProvider)
    }
    
    public func dismiss(_ completion: @escaping (() -> Void) = { }) {
        delegate?.alertView(self, shouldDismissWithCompletion: completion)
    }
    
    open func busy() {
    }
    
    open func free() {
    }
}

open class DSSAlertController<T: DSSAlertView>: UIViewController {
    // MARK: - Types
    
    open class ActionButton: UIButton {        
        public convenience init(action: DSSAlertAction) {
            self.init(type: .system)
            setTitle(action.title, for: .normal)
            addTarget(action, action: #selector(action.handleAction), for: .touchUpInside)
            
            additionalSetup()
        }
        
        open func additionalSetup() { }
    }
    
    // MARK: - Properties
    
    public let alertView: T
    
    open var transitionDuration: TimeInterval { return 0.3 }
    
    // MARK: - Init
    
    public init(_ alertView: T) {
        self.alertView = alertView
        super.init(nibName: nil, bundle: Bundle.main)
        modalPresentationStyle = .overFullScreen
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBackdrop()
    }
    
    private func setupViews() {
        view.addSubview(alertView)
        
        alertView.setupLayout(superview: view)
        view.alpha = 0
        alertView.delegate = self
    }
    
    open func setupBackdrop() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentAlert(alertView)
    }
    
    /// This method is called once the view controller appeares on the screen. Note that UIVIewController.view will have a alpha = 0 when executing this method
    /// Implement a custom presentation if necessary.
    open func presentAlert(_ alertView: T) {
        alertView.transform = .init(scaleX: 1.2, y: 1.2)
        let animation: () -> Void = { [weak self] in
            self?.view.alpha = 1
            alertView.transform = .identity
        }
        
        UIView.animate(
            withDuration: transitionDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: animation
        ) { [weak self] _ in
            guard let self = self else { return }
            self.viewControllerDidPresentAlert(self.alertView)
        }
    }
    
    open func viewControllerDidPresentAlert(_ alertView: T) {
    }
    
    open func dismiss(_ completion: @escaping () -> Void = { }) {
        view.endEditing(true)
        
        let animations: () -> Void = { [weak self] in
            self?.alertView.transform = .init(scaleX: 0.1, y: 0.1)
            self?.view.alpha = 0
        }
        
        UIView.animate(
            withDuration: transitionDuration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: animations
        ) { _ in
            self.dismiss(animated: false, completion: completion)
//            self?.didMove(toParent: nil)
//            self?.removeFromParent()
//            self?.view.removeFromSuperview()
//            completion()
        }
    }    
}

extension DSSAlertController: DSSAlertViewDelegate {
    public func alertView(_ alertView: DSSAlertView, shouldDismissWithCompletion completion: @escaping () -> Void) {
        dismiss(completion)
    }
}
