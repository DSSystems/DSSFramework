//
//  DSSSquareButton.swift
//  DSSFramework
//
//  Created by David on 21/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSSquareButton: UIControl {
    public enum InsetStyle {
        case `default`, small, none
    }
    
    override public var tintColor: UIColor! {
        didSet {
            imageView.tintColor = tintColor
            titleLabel.textColor = tintColor
        }
    }
    
    open var image: UIImage? {
        didSet { imageView.image = image?.withRenderingMode(.alwaysTemplate) }
    }
    
    open var title: String? {
        didSet {
            titleLabel.text = title
            titleLabelHeightAnchor?.constant = title == nil ? 0 : font.lineHeight * CGFloat(numberOfLines > 0 ? numberOfLines : 1)
        }
    }
    
    private let insetStyle: InsetStyle
    
    open var numberOfLines: Int {
        get { titleLabel.numberOfLines }
        set {
            titleLabelHeightAnchor?.constant = title == nil ? 0 : font.lineHeight * CGFloat(newValue > 0 ? newValue : 1)
            titleLabel.numberOfLines = newValue
        }
    }
    
    open var adjustsFontToFitWidth: Bool {
        get { titleLabel.adjustsFontSizeToFitWidth }
        set { titleLabel.adjustsFontSizeToFitWidth = newValue }
    }
    
    internal let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    internal var titleLabelHeightAnchor: NSLayoutConstraint?
    
    private let font: UIFont
    
    public init(
        image: UIImage?,
        title: String?,
        font: UIFont,
        renderingMode: UIImage.RenderingMode = .alwaysTemplate,
        insetStyle: InsetStyle = .default
    ) {
        self.image = image
        self.title = title
        self.font = font
        self.insetStyle = insetStyle
        
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.font = font
        imageView.image = image?.withRenderingMode(renderingMode)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        let titleLabelHeight = titleLabel.text == nil ? 0 : font.lineHeight
        
        let titleInsets: UIEdgeInsets = {
            switch insetStyle {
            case .default: return .init(top: 0, left: 4, bottom: 4, right: 4)
            case .small: return .init(top: 0, left: 2, bottom: 2, right: 2)
            case .none: return .zero
            }
        }()
        
        titleLabel.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: titleInsets
        )
        titleLabelHeightAnchor = titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight)
        titleLabelHeightAnchor?.isActive = true
        
        let imageInsets: UIEdgeInsets = {
            switch insetStyle {
            case .default: return .init(top: 8, left: 8, bottom: 4, right: 8)
            case .small: return .init(top: 4, left: 4, bottom: 2, right: 4)
            case .none: return .init(top: 0, left: 0, bottom: 1, right: 0)
            }
        }()
        
        imageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: titleLabel.topAnchor,
            trailing: trailingAnchor,
            padding: imageInsets
        )
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.5
        }
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let lastTouch = touches.first, !self.bounds.contains(lastTouch.location(in: self)) else { return }
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
        
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
