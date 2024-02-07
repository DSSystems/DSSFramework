//
//  Shared.swift
//  DSSFramework
//
//  Created by David on 15/10/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation

infix operator ???: NilCoalescingPrecedence
public func ???<T>(optionalValue: T?, defaultValue: @autoclosure () -> String) -> String {
    optionalValue.map { String(describing: $0) } ?? defaultValue()
}

public extension NSNull {
    static let `nil` = NSNull()
}
