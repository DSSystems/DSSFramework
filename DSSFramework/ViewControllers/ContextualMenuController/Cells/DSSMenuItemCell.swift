//
//  DSSMenuItemCell.swift
//  DSSFramework
//
//  Created by David on 28/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSMenuItemCell: DSSCollectionViewCell {
    // MARK: - Properties
    
    public static var itemHeight: CGFloat = 40
    
    var item: DSSMenuItem? {
        didSet {
            
            if let image = item?.image {
                imageView.image = image
                textLabelLeadingConstraint?.constant = Self.itemHeight
            } else {
                imageView.image = nil
                textLabelLeadingConstraint?.constant = 8
            }
            
            textLabel.text = item?.title
        }
    }
    
    public let imageView: UIImageView = .init(contentMode: .scaleToFill)
    public let textLabel: UILabel = .init(text: nil, textAlignment: .center, font: nil)
    private var textLabelLeadingConstraint: NSLayoutConstraint?
    
    // MARK: - Handlers
    
    open override func setup() {
        backgroundColor = .clear
        
        addSubview(imageView)
        addSubview(textLabel)
        
        imageView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: nil,
                         padding: .init(top: 8, left: 8, bottom: 8, right: 0))
        imageView.widthAnchor(Self.itemHeight - 16)
        
        textLabel.anchor(top: topAnchor,
                         leading: nil,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 8))
        textLabelLeadingConstraint = textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        textLabelLeadingConstraint?.isActive = true
        
        textLabel.textColor = .init(light: .gray, dark: .lightGray)
    }
}
