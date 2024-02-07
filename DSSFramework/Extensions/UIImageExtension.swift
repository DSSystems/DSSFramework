//
//  UIImageExtension.swift
//  DSSFramework
//
//  Created by David on 20/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

open class DSSCacheWrapper<T: AnyObject> {
    private let cache: NSCache<NSString, T> = .init()
    
    public func set(_ object: T, forKey key: String) {
        cache.setObject(object, forKey: .init(string: key))
    }
    
    public func get(forKey key: String) -> T? {
        cache.object(forKey: .init(string: key))
    }
}

fileprivate final class UIImageCache: DSSCacheWrapper<UIImage> {
    static let shared: UIImageCache = .init()
}

extension UIImageView {
    public func loadGif(name: String, completion: @escaping () -> Void = {}) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
                completion()
            }
        }
    }

    @available(iOS 9.0, *)
    public func loadGif(asset: String, completion: @escaping () -> Void = {}) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
                completion()
            }
        }
    }

}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?): return l < r
    case (nil, _?): return true
    default: return false
    }
}

public extension UIImage {
    private class var cache: UIImageCache { .shared }
        
    /// returns height/width
    var aspectRatio: CGFloat { size.height / size.width }
    
    func resized(maxWidth width: CGFloat, maxHeight height: CGFloat, shouldMagnify: Bool = false) -> UIImage {
        let oldWidth = size.width
        let oldHeight = size.height
        
        if !shouldMagnify, oldWidth <= width, oldHeight <= height { return self }
        
        let scaleFactor = oldWidth > oldHeight ? width / oldWidth : height / oldHeight
        
        let newSize = CGSize(width: oldWidth * scaleFactor, height: oldHeight * scaleFactor)
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    func noir(cacheKey: String? = nil) -> UIImage? {
        if let key = cacheKey, let cachedImage = Self.cache.get(forKey: key) {
            return cachedImage
        }
        
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        guard let output = currentFilter.outputImage,
              let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        
        let image = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        
        if let key = cacheKey { Self.cache.set(image, forKey: key) }
        
        return image
    }
}

public func noir(cacheKey: String?) -> (UIImage) -> UIImage? {
    { $0.noir(cacheKey: cacheKey) }
}

extension UIImage {
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(
                cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
            ),
            to: CFDictionary.self
        )
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(
                gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()
            ),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(
                    gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()
                ),
                to: AnyObject.self
            )
        }
                
        return max(delayObject as! Double, 0.1)
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        guard !array.isEmpty else { return 1 }
        var gcd = array[0]
        for val in array { gcd = UIImage.gcdForPair(val, gcd) }
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        let imagesData: [(image: CGImage, delay: Double)] =  (0..<count).compactMap {
            guard let image = CGImageSourceCreateImageAtIndex(source, $0, nil) else { return nil }
            let delaySeconds = UIImage.delayForImageAtIndex($0, source: source)
            return (image, delaySeconds * 500)
        }
                
        let duration: Double = imagesData.reduce(0, { (sum, data) -> Double in sum + data.delay })
        let gcd = gcdForArray(imagesData.map { Int($0.delay) })
        
        let frames: [[UIImage]] =  imagesData.compactMap { data in
            let frameCount = Int(data.delay) / gcd
//            return [UIImage(cgImage: data.image)]
            return (0..<frameCount).map({ _ in
                UIImage(cgImage: data.image)
            })
        }
        return .animatedImage(with: frames.flatten(UIImage.self), duration: duration / 1000.0)
    }
    
    public class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            let error = NSError(
                domain: Bundle.main.bundleIdentifier ?? "com.dssystems.erro",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Image doesn't exist"]
            )
            DSSConsole.log(error: error, localizedDescription: error.localizedDescription, sender: self)
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    public class func gif(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
                .url(forResource: name, withExtension: "gif") else {
            let error = NSError(
                domain: Bundle.main.bundleIdentifier ?? "com.dssystems.erro",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Image with name \(name) does not exist"]
            )
            DSSConsole.log(error: error, localizedDescription: error.localizedDescription, sender: self)
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            let error = NSError(
                domain: Bundle.main.bundleIdentifier ?? "com.dssystems.erro",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Cannot turn image named \"\(name)\" into NSData"]
            )
            DSSConsole.log(error: error, localizedDescription: error.localizedDescription, sender: self)
            return nil
        }
        
        return gif(data: imageData)
    }
}
