//
//  DSSImagePickerControllerDelegate.swift
//  DSSFramework
//
//  Created by David on 20/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public final class DSSImagePickerControllerDelegate: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    public var sender: Any?
    public var didPickImageHandler: ((UIImage) -> Void)?
    public var didCancelHandler: (() -> Void)?
    
    @objc public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        let image: UIImage = {
            if let image = info[.editedImage] as? UIImage {
                return image
            } else if let image = info[.originalImage] as? UIImage {
                return image
            } else {
                fatalError("This should never happen?")
            }
        }()
        
        if let imageView = sender as? UIImageView {
            imageView.image = image
        }
        
        didPickImageHandler?(image)
        sender = nil
        
        picker.dismiss(animated: true)
    }
    
    @objc public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        didCancelHandler?()
        picker.dismiss(animated: true)
    }
}
