//
//  DSSUserDefault.swift
//  DSSFramework
//
//  Created by David on 31/03/21.
//  Copyright © 2021 DS_Systems. All rights reserved.
//

import Foundation

@propertyWrapper
public struct DSSUserDefault<Value> {
    private let key: String
    private let defaultValue: Value
    
    public init<Key: RawRepresentable>(key: Key, default defaultValue: Value) where Key.RawValue == String {
//        let bundle = Bundle.main.bundleIdentifier ?? "com.ds_systems"
        self.key = key.rawValue//"\(bundle).userDefaults.\(key.rawValue)"
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value {
        get { UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }
    
    public var projectedValue: Self { self }
    
    public func remove() { UserDefaults.standard.removeObject(forKey: key) }
}
