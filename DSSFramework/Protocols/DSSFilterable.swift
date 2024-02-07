//
//  DSSFilterable.swift
//  DSSFramework
//
//  Created by David on 25/02/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation

public protocol DSSFilterable {
    func compare(withQuery query: String) -> Bool
}

public extension DSSFilterable {
    func compare(withQuery query: String) -> Bool {
        return true
    }
}

public extension String {
    var queryString: String {
        return self.replacingOccurrences(of: "á", with: "s")
            .replacingOccurrences(of: "é", with: "e")
            .replacingOccurrences(of: "í", with: "i")
            .replacingOccurrences(of: "ó", with: "o")
            .replacingOccurrences(of: "ú", with: "u")
            .replacingOccurrences(of: "ñ", with: "n")
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
    }
}

public extension Array where Element: DSSFilterable {
    func filter(withQuery query: String) -> [Element] {
        return self.compactMap { $0.compare(withQuery: query) ? $0 : nil }
    }
}
