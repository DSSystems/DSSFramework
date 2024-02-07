//
//  DSSBasicBusyTableCell.swift
//  DSSFramework
//
//  Created by David on 07/11/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

open class DSSBasicBusyTableCell: DSSTableViewCell {
    public enum Status: Equatable {
        case loading, message(text: String), done
    }
    
    open var status: Status? {
        didSet {
            guard let status = status else { return prepareForReuse() }
            switch status {
            case .loading:
                activityIndicatorView.startAnimating()
                descriptionLabel.text = nil
            case .message(let text):
                activityIndicatorView.stopAnimating()
                descriptionLabel.text = text
            case .done:
                activityIndicatorView.stopAnimating()
                descriptionLabel.text = nil
            }
        }
    }
    
    public let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    public let descriptionLabel = UILabel(
        text: nil,
        textAlignment: .center,
        font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
    ).withNumberOfLines(0)
    
    open override func setup() {
        contentView.addSubviews(descriptionLabel, activityIndicatorView)
        
        activityIndicatorView.fillToSuperview()
        descriptionLabel.fillToSuperview()
    }
}
