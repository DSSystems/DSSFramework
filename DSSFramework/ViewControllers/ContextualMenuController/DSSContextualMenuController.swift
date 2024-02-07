//
//  DSSContextualMenuController.swift
//  DSSFramework
//
//  Created by David on 28/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSContextualMenuControllerDelegate: AnyObject {
    func contextualMenuController(_ contextualMenuController: DSSContextualMenuController,
                                  didSelect option: DSSMenuItem,
                                  section: DSSMenuSection,
                                  indexPath: IndexPath)
}

extension Array where Element == DSSMenuSection {
    func height() -> CGFloat {
        return reduce(CGFloat(count) * DSSMenuItemCell.itemHeight) { (result, section) -> CGFloat in
            return result + CGFloat(section.items.count) * DSSMenuItemCell.itemHeight
        }
    }
}

extension Array where Element == DSSMenuItem {
    func width() -> CGFloat {
        0
    }
}

open class DSSContextualMenuController: UIViewController {
    
    // MARK: - Types
    
    // MARK: - Properties
    
    public var delegate: DSSContextualMenuControllerDelegate?
        
    private var sections: [DSSMenuSection]
    
    private let senderFrame: CGRect
    
    private let axis: UICollectionView.ScrollDirection
    
    public let menuCollectionView: UICollectionView
    
    private let manager: DSSContextualMenuManager
    
    public var cornerRadius: CGFloat? {
        didSet {
            menuCollectionView.layer.cornerRadius = cornerRadius ?? 0
            menuCollectionView.superview?.layer.cornerRadius = cornerRadius ?? 0
        }
    }
    
    private let dismissView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    public var visibleOptions: Int = 4
    
    // MARK: - Init
    
    public init(sections: [DSSMenuSection], senderFrame frame: CGRect, axis: UICollectionView.ScrollDirection = .vertical) {
        self.sections = sections
        manager = .init(sections: sections, axis: axis, senderFrame: frame)
        menuCollectionView = .init(frame: .zero, collectionViewLayout: manager.layout)
        self.axis = axis
        senderFrame = frame
        super.init(nibName: nil, bundle: nil)
    }
    
    public init(section: DSSMenuSection, senderFrame frame: CGRect, axis: UICollectionView.ScrollDirection = .vertical) {
        self.sections = [section]
        manager = .init(section: section, axis: axis, senderFrame: frame)
        menuCollectionView = .init(frame: .zero, collectionViewLayout: manager.layout)
        senderFrame = frame
        self.axis = axis
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.clipsToBounds = true
        
        view.backgroundColor = .init(white: 0, alpha: 0.5)
        menuCollectionView.backgroundColor = .clear
        menuCollectionView.showsVerticalScrollIndicator = false
        menuCollectionView.showsHorizontalScrollIndicator = false
        manager.delegate = self
        manager.registerCells(collectionView: menuCollectionView)
        manager.setup(collectionView: menuCollectionView)
        
        view.addSubview(dismissView)
        view.addSubview(containerView)
        containerView.addSubview(menuCollectionView)
        menuCollectionView.fillToSuperview()
        
        let size: CGSize = {
            switch axis {
            case .horizontal:
                return .init(width: senderFrame.width, height: DSSMenuItemCell.itemHeight)
            case .vertical:
                let height = min(CGFloat(visibleOptions + 1) * DSSMenuItemCell.itemHeight, sections.height())
                return .init(width: senderFrame.width, height: height)
            @unknown default: fatalError("Apple added a new case to UICollectionView.ScrollDirection.")
            }
        }()
        
        let verticalShift: CGFloat =
            (senderFrame.minY + size.height) > view.frame.maxY ? senderFrame.minY + size.height - view.frame.maxY - bottomSafeAreaHeight : 0
        
        let padding = UIEdgeInsets(top: max(statusBarFrame.height, senderFrame.minY) - verticalShift, left: senderFrame.minX, bottom: 0, right: 0)
        containerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: padding, size: size)
        
        dismissView.fillToSuperview()
        
        menuCollectionView.transform = .init(translationX: 0, y: -size.height)
        
        dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        setupColors()
    }
    
    private func setupColors() {
        menuCollectionView.layer.borderWidth = 1
        menuCollectionView.backgroundColor = UIColor(light: .init(white: 1, alpha: 0.9), dark: .init(white: 0, alpha: 0.9))
        
        menuCollectionView.layer.borderColor = UIColor.resolved(.systemGray, with: traitCollection).cgColor
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuCollectionView.transform = .identity
        }, completion: nil)
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        menuCollectionView.layer.borderColor = UIColor.resolved(.systemGray, with: traitCollection).cgColor
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
}

extension DSSContextualMenuController: DSSContextualMenuManagerDelegate {
    func contextualMenuManager(_ contextualMenuManager: DSSContextualMenuManager,
                               didSelectOption option: DSSMenuItem,
                               section: DSSMenuSection,
                               indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.contextualMenuController(self, didSelect: option, section: section, indexPath: indexPath)
        }
    }
}
