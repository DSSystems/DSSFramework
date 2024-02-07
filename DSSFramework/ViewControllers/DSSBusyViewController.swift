//
//  DSSBusyViewController.swift
//  DSSFramework
//
//  Created by David on 10/04/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

open class DSSBusyViewController: UIViewController {
    public enum ContentMode {
        case light, dark
    }
    
    private let contentMode: ContentMode
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .gray)
        
        return activityView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(text: nil, textAlignment: .left, font: .systemFont(ofSize: UIFont.systemFontSize))
        return label
    }()
    
    private lazy var containerView: DSSCurvedView = {
        let view = DSSCurvedView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private var descriptionWidth: CGFloat {
        guard let description = descriptionLabel.text else { return 0 }
        let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        let descriptionTextWidth = description.width(withConstrainedHeight: font.lineHeight, font: font)
        return descriptionTextWidth
    }
    
    public init(description: String = "LOCAL:Loading".localized, contentMode: ContentMode) {
        self.contentMode = contentMode
        super.init(nibName: nil, bundle: nil)
        descriptionLabel.text = description
        switch contentMode {
        case .light:
            descriptionLabel.textColor = .black
            activityIndicatorView.style = .gray
            containerView.backgroundColor = .white
        case .dark:
            descriptionLabel.textColor = .white
            activityIndicatorView.style = .white
            containerView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        }
        
        modalPresentationStyle = .overFullScreen
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(containerView)
        containerView.addSubview(activityIndicatorView)
        containerView.addSubview(descriptionLabel)
        
        let containerHeight = descriptionLabel.font.lineHeight + 32
        let containerWidth = min(descriptionWidth + containerHeight + 24, view.frame.size.width - 32)
        containerView.anchor(top: nil, leading: nil,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor,
                             trailing: nil,
                             padding: .init(top: 0, left: 0, bottom: view.frame.size.width * 0.08, right: 0),
                             size: .init(width: containerWidth, height: containerHeight))
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        activityIndicatorView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: nil)
        activityIndicatorView.widthAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        descriptionLabel.anchor(top: containerView.topAnchor, leading: activityIndicatorView.trailingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        
        containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 1
            self.containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { [weak self] (_) in
            guard let self = self else { return }
            self.activityIndicatorView.startAnimating()
        }
    }
        
    public func dismiss(_ completion: (() -> Void)? = nil) {
        activityIndicatorView.stopAnimating()
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.alpha = 0
            self.containerView.transform = .init(scaleX: 0.5, y: 0.5)
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
            completion?()
        }
    }
    
    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
