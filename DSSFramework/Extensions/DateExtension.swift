//
//  DateExtension.swift
//  DSSFramework
//
//  Created by David on 07/05/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation

public extension Date {
    init?(stringTimestamp: String) {
        guard let timestamp = Double(stringTimestamp), !timestamp.isNaN else { return nil }
        self.init(timeIntervalSince1970: timestamp)
    }
    
    init?(stringTimestampMS: String) {
        guard let timestamp = Double(stringTimestampMS), !timestamp.isNaN else { return nil }
        
        self.init(timeIntervalSince1970: timestamp / 1000)
    }
}
