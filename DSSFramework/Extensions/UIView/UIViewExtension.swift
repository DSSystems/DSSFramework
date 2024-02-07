//
//  UIViewExtension.swift
//  DSSFramework
//
//  Created by David on 09/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func usesAutolayout() -> Self { translatesAutoresizingMaskIntoConstraints = false; return self }
    
    @discardableResult
    func anchor(top topAnchor: NSLayoutYAxisAnchor, padding: CGFloat = 0) -> Self {
        self.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        return self
    }
    
    @discardableResult
    func anchor(leading leadingAnchor: NSLayoutXAxisAnchor, padding: CGFloat = 0) -> Self {
        self.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        return self
    }
    
    @discardableResult
    func anchor(bottom bottomAnchor: NSLayoutYAxisAnchor, padding: CGFloat = 0) -> Self {
        self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        return self
    }
    
    @discardableResult
    func anchor(trailing trailingAnchor: NSLayoutXAxisAnchor, padding: CGFloat = 0) -> Self {
        self.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchor(_ widthAnchor: NSLayoutDimension, padding: CGFloat = 0, multiplier: CGFloat = 1) -> Self {
        self.widthAnchor.constraint(equalTo: widthAnchor, multiplier: multiplier, constant: -padding).isActive = true
        return self
    }
    
    @discardableResult
    func heightAnchor(_ heightAnchor: NSLayoutDimension, padding: CGFloat = 0, multiplier: CGFloat = 1) -> Self {
        self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: multiplier, constant: -padding).isActive = true
        return self
    }
    
    @discardableResult
    func widthAnchor(_ constant: CGFloat) -> Self { widthAnchor.constraint(equalToConstant: constant).isActive = true; return self }
    @discardableResult
    func heightAnchor(_ constant: CGFloat) -> Self { heightAnchor.constraint(equalToConstant: constant).isActive = true; return self }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) -> Self {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topAnchor = top { anchor(top: topAnchor, padding: padding.top) }
        if let leadingAnchor = leading { anchor(leading: leadingAnchor, padding: padding.left) }
        if let bottomAnchor = bottom { anchor(bottom: bottomAnchor, padding: padding.bottom) }
        if let trailingAnchor = trailing { anchor(trailing: trailingAnchor, padding: padding.right) }
        
        if size.width > 0 { widthAnchor(size.width) }
        if size.height > 0 { heightAnchor(size.height) }
        
        return self
    }
    
//    @discardableResult
//    func anchor(top: NSLayoutYAxisAnchor? = nil,
//                leading: NSLayoutXAxisAnchor? = nil,
//                bottom: NSLayoutYAxisAnchor? = nil,
//                trailing: NSLayoutXAxisAnchor? = nil,
//                padding: UIEdgeInsets = .zero,
//                height: CGFloat = 0) -> Self {
//        anchor(top: top,
//               leading: leading,
//               bottom: bottom,
//               trailing: trailing,
//               padding: padding,
//               size: .init(width: 0, height: height)
//        )
//    }
//    
//    @discardableResult
//    func anchor(top: NSLayoutYAxisAnchor? = nil,
//                leading: NSLayoutXAxisAnchor? = nil,
//                bottom: NSLayoutYAxisAnchor? = nil,
//                trailing: NSLayoutXAxisAnchor? = nil,
//                padding: UIEdgeInsets = .zero,
//                width: CGFloat = 0) -> Self {
//        anchor(top: top,
//               leading: leading,
//               bottom: bottom,
//               trailing: trailing,
//               padding: padding,
//               size: .init(width: width, height: 0)
//        )
//    }
    
    @discardableResult
    func center(to view: UIView, safeArea: Bool = false, offset: (x: CGFloat, y: CGFloat) = (0, 0)) -> Self {
        guard safeArea else {
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).isActive = true
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).isActive = true
            return self
        }
        
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: offset.x).isActive = true
        centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: offset.y).isActive = true
        return self
    }
    
    @discardableResult
    func centerHorizontally(to view: UIView, offset: CGFloat = 0) -> Self {
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset).isActive = true
        return self
    }
    
    @discardableResult
    func centerVertically(to view: UIView, offset: CGFloat = 0) -> Self {
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive = true
        return self
    }
    
    func constraintToIntrinsicHeight() {
        heightAnchor(intrinsicContentSize.height)
    }
    
    func constraintToIntrinsicWidth() {
        heightAnchor(intrinsicContentSize.width)
    }
        
    func fillToSuperviewSafeArea(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        anchor(
            top: superview.safeAreaLayoutGuide.topAnchor,
            leading: superview.safeAreaLayoutGuide.leadingAnchor,
            bottom: superview.safeAreaLayoutGuide.bottomAnchor,
            trailing: superview.safeAreaLayoutGuide.trailingAnchor,
            padding: padding
        )
    }
    
    func fillToSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        anchor(top: superview.topAnchor,
               leading: superview.leadingAnchor,
               bottom: superview.bottomAnchor,
               trailing: superview.trailingAnchor,
               padding: padding)
    }
    
    var bottomSafeAreaHeight: CGFloat {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    func randomizeSubviewsColor() {
        #if DEBUG
//        subviews.forEach { $0.backgroundColor = .cyan }
        subviews.forEach {
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.red.cgColor
        }
        #endif
    }
}

// MARK: Animated actions
public extension UIView {
    
    /// Remove the view from the superview and sets its alpha valute to *alpha* (default value is 0).
    func removeFromSuperview(duration: TimeInterval, alpha: CGFloat = 0, _ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }) { [weak self] _ in
            self?.removeFromSuperview()
            completion?()
        }
    }
    
    func add(toView view: UIView, duration: TimeInterval, alpha: CGFloat = 1, _ completion: (() -> Void)? = nil) {
        removeFromSuperview()
        view.addSubview(self)
        guard self.alpha < 1 else { return }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        }) { _ in
            completion?()
        }
    }
    
    func show(animationDuration duration: TimeInterval = 0.3, _ completion: @escaping () -> Void = { }) {
        isHidden = false
        guard duration > 0 else {
            alpha = 1
            completion()
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }) { _ in
            completion()
        }
    }
    
    func hide(animationDuration duration: TimeInterval = 0.3, _ completion: @escaping () -> Void = { }) {
        guard duration > 0 else {
            alpha = 0
            isHidden = true
            completion()
            return
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            completion()
        }
    }
    
    func expandAnimation(initialScale: (x: CGFloat, y: CGFloat) = (x: 0.0001, y: 0.0001),
                         duration: TimeInterval,
                         options: UIView.AnimationOptions,
                         _ completion: @escaping (Bool) -> Void) {
        transform = CGAffineTransform(scaleX: initialScale.x, y: initialScale.y)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: options, animations: { [weak self] in
                        
                        self?.transform = .identity
        }, completion: completion)
    }
    
    func shrinkAnimation(finalState: (x: CGFloat, y: CGFloat) = (x: 0.0001, y: 0.0001),
                         duration: TimeInterval,
                         options: UIView.AnimationOptions,
                         _ completion: @escaping (Bool) -> Void) {
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: options, animations: { [weak self] in
                        self?.transform = CGAffineTransform(scaleX: finalState.x, y: finalState.y)
            }, completion: completion)
    }
    
    enum SlideAnimationDirection {
        case top, left, bottom, right
    }
    func slideAnimation(direction: SlideAnimationDirection,
                        shift: CGFloat = 50,
                        duration: TimeInterval = 0.5,
                        delay: TimeInterval = 0,
                        _ completion: @escaping (Bool) -> Void ) {
        
        let transform: CGAffineTransform = {
            switch direction {
            case .top: return .init(translationX: 0, y: -shift)
            case .left: return .init(translationX: -shift, y: 0)
            case .bottom: return .init(translationX: 0, y: shift)
            case .right: return .init(translationX: shift, y: 0)
            }
        }()
        
        self.transform = transform
        alpha = 0
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            self?.alpha = 1
            self?.transform = .identity
            }, completion: completion)
    }
}

public extension UIView {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
    }
    
    @discardableResult
    func withBackground(color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func with(cornerRadius radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        clipsToBounds = true
        return self
    }
    
    func with(contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    /// Returns the Rect relative to screens' frame. It returns CGRect.zero if there is no active view controllers
    var absoluteFrame: CGRect {
        guard let topController = UIApplication.shared.topViewController() else { return .zero }
        return convert(bounds, to: topController.view)
    }
}

public extension UIView {
    class func new<View: UIView>(frame: CGRect = .zero, _ configure: (View) -> Void) -> View {
        let view = View(frame: frame)
        configure(view)
        return view
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func wrapped(padding: UIEdgeInsets, backgroundColor: UIColor) -> UIView {
        let wrapperView = UIView().withBackground(color: backgroundColor)
        wrapperView.addSubview(self)
        fillToSuperview(padding: padding)
        return wrapperView
    }
}

public extension UIView {
    func getConstraint(with identifier: NSLayoutConstraint.Identifier) -> NSLayoutConstraint? {
        constraints.first(where: { $0.identifier == identifier.rawValue })
    }
}

extension UIView {
    public class BorderLayer: CAShapeLayer {
        var isBorderLayer: Bool { true }
    }
    
    @objc open func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: .square(withArista: radius)
        )
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    @objc open func addBorder(corners: UIRectCorner, radius: CGFloat, color: CGColor) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: .square(withArista: radius)
        )
        
        let borderLayer = BorderLayer()
        borderLayer.path = path.cgPath // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color
        borderLayer.lineWidth = 1
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
}

@propertyWrapper
public class UsesAutoLayout<V: UIView> {
    public var wrappedValue: V
    
    public init(wrappedValue: V) {
        self.wrappedValue = wrappedValue
        wrappedValue.usesAutolayout()
    }
}
