//
//  UIImageViewExtension.swift
//  DSSFramework
//
//  Created by David on 01/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UIImageView {
    convenience init(contentMode: UIView.ContentMode) {
        self.init(frame: .zero)
        self.contentMode = contentMode
    }
    
    convenience init(imageName: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.init(frame: .zero)
        if let image = UIImage(named: imageName) {
            self.image = image
        } else {
            print("UIImageView: Failed to retrieve image with name '\(imageName)'.")
        }
        self.contentMode = contentMode
    }
    
    convenience init(image: UIImage, contentMode: UIView.ContentMode) {
        self.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
    }
    
    func clipsToBounds() -> Self {
        clipsToBounds = true
        return self
    }
}

extension UIImageView {
    private func gif(asset: String) -> [UIImage] {
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return []
        }

        guard let source =  CGImageSourceCreateWithData(dataAsset.data as CFData, nil) else { return [] }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        return images
    }
    
    public func animateGIF(fromAsset asset: String, duration: TimeInterval, repeatCount: Int, completion: @escaping () -> Void) {
        let images = gif(asset: asset)
        let lastImage = images.last
        
        animationImages = images
        animationDuration = duration
        animationRepeatCount = repeatCount
        
        startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(repeatCount) * duration) {
            self.animationImages = nil
            self.image = lastImage
            completion()
        }
    }
}
