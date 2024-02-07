//
//  DSSTextFieldDataProvider.swift
//  DSSFramework
//
//  Created by David on 10/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public protocol DSSTextFieldDataProvider {
    var placeholder: String? { get }
    
    var keyboardType: UIKeyboardType { get }
    
    var returnKeyType: UIReturnKeyType { get }
    
    var get: (() -> String?) { get set }
    
    var set: ((String?) -> Void)? { get set }
    
    var doneCompletion: ((UITextField) -> Void)? { get set }
    
    func setup(_ textField: UITextField)
}

public extension DSSTextFieldDataProvider {
    var keyboardType: UIKeyboardType { .default }
    var returnKeyType: UIReturnKeyType { .done }
    var set: ((String) -> Void)? { nil }
    var doneCompletion: ((UITextField) -> Void)? { nil }
    
    func setup(_ textField: UITextField) { }
}
