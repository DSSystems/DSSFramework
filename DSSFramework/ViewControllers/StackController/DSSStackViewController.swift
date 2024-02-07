//
//  DSSStackViewController.swift
//  DSSFramework
//
//  Created by David on 15/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public typealias DSSStackableView = UIView & DSSSizable
public protocol DSSSizable where Self: UIView {
    func size(relativeTo size: CGSize) -> CGSize
}

//public extension DSSSizable {
//    func width(forHeight height: CGFloat) -> CGFloat {
//        return self.intrinsicContentSize.width
//    }
//    
//    func height(forWidth width: CGFloat) -> CGFloat {
//        return self.intrinsicContentSize.height
//    }
//}

open class DSSStackViewController: UIViewController {
    
    // MARK: - Properties
    
    var arrangedViews: [DSSStackableView] {
        return stackView.arrangedSubviews.map {
            guard let view = $0 as? DSSStackableView else {
                fatalError("Element in DSSStackViewController.UIStackView is not a DSSStackableView.")
            }
            return view
        }
    }
    
    open var headerView: UIView? {
        willSet {
            guard let headerView = headerView else { return }
            headerView.removeFromSuperview()
            scrollView.contentInset.top = scrollView.contentInset.top - headerView.frame.height
            scrollView.scrollIndicatorInsets.top = scrollView.scrollIndicatorInsets.top - headerView.frame.height
        }
        didSet {
            guard let headerView = headerView else { return }
            view.addSubview(headerView)
            headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: view.trailingAnchor,
                              size: headerView.frame.size)
            
            scrollView.contentInset.top = scrollView.contentInset.top + headerView.frame.height
            scrollView.scrollIndicatorInsets.top = scrollView.scrollIndicatorInsets.top + headerView.frame.height
            
            scrollView.contentOffset.y = -scrollView.contentInset.top
        }
    }
    
    open var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            stackView.axis = axis
            setupStackViewDimensions()
        }
    }
    
    open var distribution: UIStackView.Distribution = .fill {
        didSet {
            stackView.distribution = distribution
        }
    }
    
    open var scrollView: UIScrollView = UIScrollView()
    open var stackView: UIStackView
    
    internal var stackViewDimensionConstraints: (width: NSLayoutConstraint?, height: NSLayoutConstraint?)
    
    // MARK: - Init
    
    public init(arrangedViews: [DSSStackableView]) {
        if arrangedViews.isEmpty {
            stackView = .init(frame: .zero)
        } else {
            stackView = .init(arrangedSubviews: arrangedViews)
        }
        super.init(nibName: nil, bundle: .main)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollAndStackViews()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupStackViewDimensions()
    }
    
    func setupScrollAndStackViews() {
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        scrollView.anchor(top: view.topAnchor,
                          leading: view.safeAreaLayoutGuide.leadingAnchor,
                          bottom: view.bottomAnchor,
                          trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        stackView.anchor(top: stackView.topAnchor,
                         leading: stackView.leadingAnchor)
    }
    
    internal func setupStackViewDimensions() {
        stackViewDimensionConstraints.width?.isActive = false
        stackViewDimensionConstraints.height?.isActive = false
        
        let height = scrollView.frameLayoutGuide.layoutFrame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        
        let width = scrollView.frameLayoutGuide.layoutFrame.width - scrollView.contentInset.left - scrollView.contentInset.right
        
        switch stackView.axis {
        case .horizontal:
            let contenWidth: CGFloat = arrangedViews.width(relativeTo: .init(width: width, height: height))
            
            stackViewDimensionConstraints.width = stackView.widthAnchor.constraint(equalToConstant: contenWidth)
            stackViewDimensionConstraints.height = stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            
            scrollView.contentSize = .init(width: contenWidth, height: height)
        case .vertical:
            let contentHeight = arrangedViews.height(relativeTo: .init(width: width, height: height))
            stackViewDimensionConstraints.width = stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            stackViewDimensionConstraints.height = stackView.heightAnchor.constraint(equalToConstant: contentHeight)
            
            scrollView.contentSize = .init(width: width, height: contentHeight)
        @unknown default: fatalError("Apple added a new case to NSLayoutConstraint.Axis.")
        }
        
        stackViewDimensionConstraints.width?.isActive = true
        stackViewDimensionConstraints.height?.isActive = true
    }
}

extension Array where Element == DSSStackableView {
    func height(relativeTo size: CGSize) -> CGFloat {
        return reduce(0) { (result, view) -> CGFloat in
            result + view.size(relativeTo: size).height
        }
    }
    
    func width(relativeTo size: CGSize) -> CGFloat {
        return reduce(0) { (result, view) -> CGFloat in
            result + view.size(relativeTo: size).width
        }
    }
}

extension DSSStackViewController: UIScrollViewDelegate {
}
