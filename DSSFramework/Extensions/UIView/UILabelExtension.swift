//
//  UILabelExtension.swift
//  DSSFramework
//
//  Created by David on 15/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public extension UILabel {
    convenience init(text: String?, textAlignment: NSTextAlignment = .left, font: UIFont? = nil) {
        self.init()
        self.text = text
        self.textAlignment = textAlignment
        if let font = font { self.font = font }
    }
    
    convenience init(alignment: NSTextAlignment, attrStrings: DSSMutableStringElement...) {
        self.init()
        let mutableAttributedText = NSMutableAttributedString()
        attrStrings.forEach { mutableAttributedText.append($0) }
        attributedText = mutableAttributedText
        self.textAlignment = alignment
    }
    
    func heightThatFits(width: CGFloat) -> CGFloat {
        if let text = text {
            return text.height(withConstrainedWidth: width, font: font, alignment: textAlignment)
        } else if let attributedText = attributedText {
            return attributedText.boundingRect(
                with: .init(width: width, height: .infinity),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                context: nil
            ).height + 4
        }
        
        return 0
    }
    
    func widthThatFits(height: CGFloat) -> CGFloat {
        guard let text = text else { return 0 }
        return text.width(withConstrainedHeight: height, font: font)
    }
    
    func withNumberOfLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    func withTextColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
    }
    
    func withFont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    
    func addInteractiveContent(_ interactiveContent: DSSInteractiveContent) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = interactiveContent.textAlignment
        let attributedString =
            NSMutableAttributedString(
                string: interactiveContent.text,
                attributes: [.font: interactiveContent.font,
                             .paragraphStyle: paragraphStyle,
                             .foregroundColor: interactiveContent.textColor]
            )
        
        interactiveContent.ranges.forEach {
            attributedString.addAttributes([.foregroundColor: interactiveContent.interactiveTextColor], range: $0)
        }
        
        self.numberOfLines = 0
        let gesture = DSSTapGestureRecognizer(target: self, action: #selector(handleInteraction))
        gesture.interactiveContent = interactiveContent
        
        self.addGestureRecognizer(gesture)
        self.isUserInteractionEnabled = true
        
        self.attributedText = attributedString
    }
    
    @objc private func handleInteraction(gesture: DSSTapGestureRecognizer) {
        guard let interactiveContent = gesture.interactiveContent else { return }
        let ranges = interactiveContent.ranges
        
        for n in 0...(ranges.count - 1) {
            if gesture.didTapAttributedTextt(in: self, inRange: ranges[n]) {
                interactiveContent.actions[n]()
                break
            }
        }
    }
}

public struct DSSInteractiveContent {
    let text: String
    let font: UIFont
    let textAlignment: NSTextAlignment
    let interactiveTextColor: UIColor
    let textColor: UIColor
    
    var ranges: [NSRange] = []
    var actions: [() -> Void] = []
    
    public init(
        text: String,
        font: UIFont,
        textColor: UIColor,
        interactiveTextColor: UIColor,
        textAlignment: NSTextAlignment = .center
    ) {
        self.text = text
        self.font = font
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.interactiveTextColor = interactiveTextColor
    }
    
    public func attributedText() -> NSAttributedString {
        return .init(string: text, attributes: [.font: font])
    }
    
    public mutating func addAction(inRange range: Range<String.Index>, action: @escaping () -> Void) {
        ranges.append(text.nsRange(from: range))
        actions.append(action)
    }
    
    public func height(forWidth width: CGFloat) -> CGFloat {
        return text.height(withConstrainedWidth: width, font: font, alignment: .left)
    }
}

class DSSTapGestureRecognizer: UITapGestureRecognizer {
    var interactiveContent: DSSInteractiveContent?
}
