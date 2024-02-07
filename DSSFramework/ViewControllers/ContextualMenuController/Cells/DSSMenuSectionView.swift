//
//  DSSMenuSectionView.swift
//  DSSFramework
//
//  Created by David on 28/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSMenuSectionView: UICollectionReusableView, DSSIdentifiable {
    // MARK: - Init
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    public let titleLabel = UILabel(text: nil, textAlignment: .center,
                                    font: .boldSystemFont(ofSize: UIFont.systemFontSize))
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    open func setupViews() {
        addSubview(titleLabel)
        
        titleLabel.fillToSuperview()
        
        titleLabel.textColor = UIColor(light: .black, dark: .white)
        
        backgroundColor = UIColor(light: .white, dark: .black)        
    }
}
