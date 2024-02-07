//
//  DSSContextualMenuManager.swift
//  DSSFramework
//
//  Created by David on 28/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public struct DSSMenuSection {
    public let title: String?
    
    public let items: [DSSMenuItem]
    
    public init(title: String? = nil, items: [DSSMenuItem]) {
        self.title = title
        self.items = items
    }
}

public struct DSSMenuItem {
    public let title: String?
    public let image: UIImage?
    
    public init(title: String) {
        self.title = title
        self.image = nil
    }
    
    public init(image: UIImage?) {
        self.title = nil
        self.image = image
    }
}

protocol DSSContextualMenuManagerDelegate: AnyObject {
    func contextualMenuManager(_ contextualMenuManager: DSSContextualMenuManager,
                               didSelectOption option: DSSMenuItem,
                               section: DSSMenuSection,
                               indexPath: IndexPath)
}

class DSSContextualMenuManager: NSObject, DSSCollectionViewManager {
    
    // MARK: - Properties
    weak var delegate: DSSContextualMenuManagerDelegate?
    
    var layout: UICollectionViewLayout
    
    var reusableCells: [CellId : CellClass] {
        return [ DSSMenuItemCell.identifier: DSSMenuItemCell.self ]
    }
    
    var reusableHeaders: [CellId : CellClass] {
        return [ DSSMenuSectionView.identifier: DSSMenuSectionView.self ]
    }
        
    private let sections: [DSSMenuSection]
    
    private let senderFrame: CGRect
    
    var weakCollectionView: WeakRef<UICollectionView>!
    
    // MARK: - Init
    
    init(sections: [DSSMenuSection],
         axis: UICollectionView.ScrollDirection, senderFrame frame: CGRect) {
        let layout = UICollectionViewFlowLayout(scrollDirection: axis, minimumLineSpacing: 0, minimumInteritemSpacing: 0)
        layout.sectionHeadersPinToVisibleBounds = true
        self.layout = layout
        self.sections = sections
        senderFrame = frame
        super.init()
    }
    
    init(section: DSSMenuSection, axis: UICollectionView.ScrollDirection, senderFrame frame: CGRect) {
        let layout = UICollectionViewFlowLayout(scrollDirection: axis, minimumLineSpacing: 0, minimumInteritemSpacing: 0)
        layout.sectionHeadersPinToVisibleBounds = true
        self.layout = layout
        self.sections = [section]
        senderFrame = frame
        super.init()
    }
    
    // MARK: - Handlers
    
    func setup(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DSSMenuItemCell.identifier, for: indexPath) as! DSSMenuItemCell
        cell.item = sections[indexPath.section].items[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: DSSMenuSectionView.identifier,
                                                                     for: indexPath) as! DSSMenuSectionView
        header.title = sections[indexPath.section].title?.uppercased()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = layout as? UICollectionViewFlowLayout else { fatalError("This should never happen!") }
        
        let height = DSSMenuItemCell.itemHeight
        let width = layout.scrollDirection == .vertical ? senderFrame.width : {
            let title = sections[indexPath.section].items[indexPath.item].title
            return title?.width(withConstrainedHeight: height,
                                font: .systemFont(ofSize: height)) ?? height
            }()
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let layout = layout as? UICollectionViewFlowLayout else { fatalError("This should never happen!") }
        
        let height = DSSMenuItemCell.itemHeight
        let width = layout.scrollDirection == .vertical ? senderFrame.width : {
            let title = sections[section].title
            return title?.width(withConstrainedHeight: height,
                                font: .systemFont(ofSize: height)) ?? height
            }()
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.contextualMenuManager(self,
                                        didSelectOption: sections[indexPath.section].items[indexPath.item],
                                        section: sections[indexPath.section],
                                        indexPath: indexPath)
    }
}
