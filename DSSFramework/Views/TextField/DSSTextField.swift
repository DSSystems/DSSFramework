//
//  DSSTextField.swift
//  DSSFramework
//
//  Created by David on 10/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSTextField: UITextField, UITextFieldDelegate {
    
    // MARK: - Properties
    
    public var dataProvider: DSSTextFieldDataProvider? {
        didSet {
            guard let dataProvider = dataProvider else {
                returnKeyType = .default
                keyboardType = .default
                text = nil
                placeholder = nil
                return
            }
            returnKeyType = dataProvider.returnKeyType
            keyboardType = dataProvider.keyboardType
            if keyboardType == .numberPad {
                let toolbar = UIToolbar(frame: .init(origin: .zero, size: .init(width: 40, height: 40)))
                let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
                let paddingItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                toolbar.setItems([paddingItem, doneButtonItem], animated: false)
                toolbar.sizeToFit()
                inputAccessoryView = toolbar
            } else {
                inputAccessoryView = nil
            }
            
            text = dataProvider.get()
            placeholder = dataProvider.placeholder
            dataProvider.setup(self)
            setup()
            
            if keyboardType == .numberPad || (inputAccessoryView == nil && inputView != nil) {
                let toolbar = UIToolbar(frame: .init(origin: .zero, size: .init(width: 40, height: 40)))
                let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
                let paddingItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                toolbar.setItems([paddingItem, doneButtonItem], animated: false)
                toolbar.sizeToFit()
                inputAccessoryView = toolbar
            } else {
                inputAccessoryView = nil
            }
        }
    }
    
    // MARK: - init
    
    public init(provider: DSSTextFieldDataProvider) {
        super.init(frame: .zero)
        
        defer { dataProvider = provider }
    }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Handlers
    
    private func setup() {
        delegate = self
        removeTarget(self, action: #selector(handleValueChanged), for: .allEditingEvents)
        addTarget(self, action: #selector(handleValueChanged), for: .allEditingEvents)
    }
    
    @objc private func handleValueChanged(textField: UITextField) {
        guard let dataProvider = dataProvider, let text = text else { return }
        dataProvider.set?(text.isEmpty ? nil : text)
    }
    
    public func update() {
        text = dataProvider?.get()
    }
    
    @objc private func handleDone(textField: UITextField) {
        resignFirstResponder()
        dataProvider?.doneCompletion?(textField)
    }
}

public extension DSSTextField {
    
    // MARK: - UITextField delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let dataProvider = dataProvider {
            switch dataProvider.returnKeyType {
            case .default: break
            case .go: break
            case .google: break
            case .join: break
            case .next: break
            case .route: break
            case .search: break
            case .send: break
            case .yahoo: break
            case .done:
                textField.resignFirstResponder()
//                dataProvider.doneCompletion?(textField)
            case .emergencyCall: break
            case .continue: break
            @unknown default: fatalError("Apple added a new case to UIReturnKeyType.")
            }
        }
        return true
    }    
}
