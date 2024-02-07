//
//  DSSKeyboardHandler.swift
//  DSSFramework
//
//  Created by David on 01/03/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

class DSSKeyboardGesture: UITapGestureRecognizer {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(handleHideKeyboard))
    }
    
    @objc private func handleHideKeyboard() {
        viewController?.view.endEditing(true)
    }
}

public protocol DSSKeyboardHandler: AnyObject {
    var controlFrame: CGRect { get }
    
    func keyboardFrameWillAppear(frame: CGRect)
    func keyboardFrameWillDisappear(frame: CGRect)
}

public extension DSSKeyboardHandler where Self: UIViewController {
    func keyboardFrameWillAppear(frame: CGRect) {
        view.frame.origin.y = -frame.size.height
    }
    
    func keyboardFrameWillDisappear(frame: CGRect) {
        view.frame.origin.y = 0
    }
}

public extension DSSKeyboardHandler where Self: UIViewController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
            
            #warning("To be improved")
            self.keyboardFrameWillAppear(frame: keyboardRectangle)
//            let offset: CGFloat = max(0, keyboardHeight - (self.view.frame.height - self.controlFrame.maxY) + 16)
//
//            self.view.frame.origin.y = self.view.frame.origin.y - offset
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }
            guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            self.keyboardFrameWillDisappear(frame: keyboardRectangle)
            #warning("To be improved")
//            let keyboardHeight = keyboardRectangle.height
//
//            let offset: CGFloat = max(0, keyboardHeight - (self.view.frame.height - self.controlFrame.maxY) + 16)
//
//            self.view.frame.origin.y = self.view.frame.origin.y + offset
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.view.addGestureRecognizer(DSSKeyboardGesture(viewController: self))
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            
            self.view.gestureRecognizers?.forEach {
                if let gesture = $0 as? DSSKeyboardGesture {
                    self.view.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}
