//
//  UITapGestureRecognizerExtension.swift
//  DSSFramework
//
//  Created by David on 24/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {
    func didTapAttributedTextt(in label: UILabel, inRange range: NSRange) -> Bool {
        guard let attributedString = label.attributedText else { return false }
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer()
        let textStorage = NSTextStorage(attributedString: attributedString)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let xOffset = (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x
        let yOffset = (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        let textContainerOffset = CGPoint(x: xOffset, y: yOffset)
        
        let xTouchLocation = locationOfTouchInLabel.x - textContainerOffset.x
        let yTouchLocation = locationOfTouchInLabel.y - textContainerOffset.y
        let locationOfTouchInTextContainer = CGPoint(x: xTouchLocation, y: yTouchLocation)
        
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, range)
    }
}
