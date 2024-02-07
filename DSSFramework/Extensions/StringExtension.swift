//
//  StringExtension.swift
//  DSSFramework
//
//  Created by David on 10/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

extension StringProtocol {
    func nsRange(from range: Range<Index>) -> NSRange {
        return .init(range, in: self)
    }
}

public extension String {
    // MARK: - Types
    
    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
        case shortAddressDescription = "^*\\,{0,1}\\s{0,1}[0-9]{1,5}+$"
        case alphabetic = "^[a-zA-Z\\s]+$"
        case alphabeticWithAccents = "^[a-zA-ZÀ-ÿ\\s]+$"
        case alphanumeric = "^[a-zA-Z0-9-\\s]+$"
//        case alphanumericWithAccents = "^[.,:;a-zA-ZÀ-ÿ0-9-\\s]+$"
        case percentageEncoded = "%[a-fA-F0-9]"
    }
    
    // MARK: - Properties
    
    var localized: String { return NSLocalizedString(self, comment: "DSSFramework") }
    
    var formattedForURL: String {
        guard let string = (self.removingPercentEncoding ?? self).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            fatalError("This should never fail")
        }
        
        return string
    }
    
    var url: URL? {
        let encodedString = isValid(.percentageEncoded) ? self : self.formattedForURL
        guard let url = URL(string: encodedString) else {
            #if DEBUG
            print("[String]: Failed to parse URL from \(self)")
            #endif
            return nil
        }
        return url
    }
    
    var getDigits: String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    var isValidEmail: Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
    
    // MARK: - Handlers
    
    func isValid(_ regex: RegularExpressions) -> Bool {
        return isValid(regex: regex.rawValue)
    }
    
    func isValid(regex: String) -> Bool {
        let matches = range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont, alignment: NSTextAlignment) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font, .paragraphStyle: paragraphStyle],
            context: nil
        )
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func call() {
        let number = self.replacingOccurrences(of: " ", with: "").getDigits
        if number.isValid(.phone) {
            if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    DispatchQueue.main.async { UIApplication.shared.open(url) }
                } else {
                    DispatchQueue.main.async { UIApplication.shared.openURL(url) }
                }
            }
        } else {
            #if DEBUG
            print(number, "Is not a valid phone number")
            #endif
        }
    }
    
    func fontHeightThatFits(in size: CGSize, font: UIFont) -> CGFloat {
        
        var fontSize = size.height
        
        var textWidth = width(withConstrainedHeight: fontSize, font: font.withSize(fontSize))
        
        while textWidth > size.width {
            fontSize -= 2
            textWidth = width(withConstrainedHeight: fontSize, font: font.withSize(fontSize))
        }
        
        return fontSize * 0.85
    }
    
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
    func draw(with rect: CGRect,
              options: NSStringDrawingOptions = [],
              attributes: [NSAttributedString.Key : Any]? = nil,
              context: NSStringDrawingContext?) {
        
        NSString(string: self).draw(with: rect, options: options, attributes: attributes, context: context)
    }
}
