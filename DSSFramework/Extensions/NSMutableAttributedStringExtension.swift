//
//  NSMutableAttributedStringExtension.swift
//  DSSFramework
//
//  Created by David on 24/01/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

public struct DSSMutableStringElement {
    public enum JumpLineType { case start, startDouble, end, endDouble, none }
    
    let jumpLine: JumpLineType
    public let text: String
    public let font: UIFont
    public let textColor: UIColor
    public let paragraphStyle: NSParagraphStyle?
    
    public var fullText: String {
        switch jumpLine {
        case .end: return text + "\n"
        case .start: return "\n" + text
        case .none: return text
        case .startDouble: return "\n\n\(text)"
        case .endDouble: return "\(text)\n\n"
        }
    }
    
    public init(text: String,
                font: UIFont,
                textColor: UIColor,
                jumpLine: JumpLineType,
                paragraphStyle: NSParagraphStyle?) {
        self.jumpLine = jumpLine
        self.text = text
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = paragraphStyle
    }
    
    public init<T>(value: T,
                   font: UIFont,
                   textColor: UIColor,
                   jumpLine: JumpLineType,
                   paragraphStyle: NSParagraphStyle?) {
        self.jumpLine = jumpLine
        self.text = "\(value)"
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = paragraphStyle
    }
    
    public init(text: String,
                font: UIFont,
                textColor: UIColor,
                jumpLine: JumpLineType) {
        self.jumpLine = jumpLine
        self.text = text
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = nil
    }
    
    public init<T>(value: T, font: UIFont, textColor: UIColor, jumpLine: JumpLineType) {
        self.jumpLine = jumpLine
        self.text = "\(value)"
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = nil
    }
    
    public init(text: String,
                font: UIFont,
                textColor: UIColor) {
        self.jumpLine = .none
        self.text = text
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = nil
    }
    
    public init<T>(value: T, font: UIFont, textColor: UIColor) {
        self.jumpLine = .none
        self.text = "\(value)"
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = nil
    }
    
    public init(text: String, font: UIFont, textColor: UIColor, paragraphStyle: NSParagraphStyle?) {
        self.jumpLine = .none
        self.text = text
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = paragraphStyle
    }
    
    public init<T>(value: T, font: UIFont, textColor: UIColor, paragraphStyle: NSParagraphStyle?) {
        self.jumpLine = .none
        self.text = "\(value)"
        self.font = font
        self.textColor = textColor
        self.paragraphStyle = paragraphStyle
    }
}

public extension NSAttributedString {
    convenience init(htmlContent: String) {
        guard let data = htmlContent.data(using: .utf8) else {
            self.init(string: htmlContent)
            return
        }
        
        do {
            try self.init(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
                documentAttributes: nil
            )
        } catch {
            self.init(string: htmlContent)
        }
    }
}

public extension NSMutableAttributedString {
//    convenience init(_ elements: [DSSMutableStringElement]) {
//        self.init(string: element.text, attributes: [.font: element.fullText, .foregroundColor: element.textColor])
//    }
    
    convenience init(_ elements: DSSMutableStringElement...) {
        self.init()
        elements.forEach { append($0) }
    }
    
    func append(_ elements: DSSMutableStringElement...) {
        elements.forEach { element in
            var attributes: [NSAttributedString.Key: Any] = [.font: element.font, .foregroundColor: element.textColor]
            if let paragraphStyle = element.paragraphStyle { attributes[.paragraphStyle] = paragraphStyle }
            let attrString = NSAttributedString(string: element.fullText, attributes: attributes)
            append(attrString)
        }
    }
}
