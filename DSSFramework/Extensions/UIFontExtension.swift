//
//  UIFontExtension.swift
//  DSSFramework
//
//  Created by David on 18/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UIFont {
    class func bold(_ font: UIFont) -> UIFont {
        font.bold
    }
    
    func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0) //size 0 means keep the size as it is
    }

    var bold: UIFont {
        return withTraits(traits: .traitBold)
    }

    var italic: UIFont {
        return withTraits(traits: .traitItalic)
    }
}
