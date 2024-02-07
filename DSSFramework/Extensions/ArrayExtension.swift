//
//  ArrayExtension.swift
//  DSSFramework
//
//  Created by David on 07/12/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import Foundation

public extension Array {
    func flatten<T>(_ type: T.Type) -> [T] {
        var flattenArray: [T] = []
        
        self.forEach {
            if let element = $0 as? T {
                flattenArray.append(element)
            }
            if let array = $0 as? [T] {
                array.flatten(T.self).forEach { flattenArray.append($0) }
            }
        }
        
        return flattenArray.compactMap({ return $0 })
    }
}

public extension Array {
    func compactMap<T>() -> [T] where Element == Optional<T> {
        compactMap { $0 }
    }
}

public extension Array where Element: Encodable {
    func data(with encoder: JSONEncoder) throws -> Data {
        try encoder.encode(self)
    }
}

public extension Set {
    static func empty() -> Self { .init() }
    
    func arrayMap<T>(_ transform: (Element) throws -> T) rethrows -> [T] {
        var array: [T?] = []
        
        forEach { array.append(try? transform($0)) }
        
        return array.compactMap()
    }
    
    func map<T: Hashable>(_ transform: (Element) throws -> T) rethrows -> Set<T> {
        var set: Set<T> = []
        forEach {
            if let element = try? transform($0) { set.insert(element) }
        }
        return set
    }
    
    static func compose<T>(from array: Set<T>, transform: (T) throws -> Element) rethrows -> Set<Element> {
        try array.compactMap(transform).set()
    }
    
    func array() -> [Element] { map { $0 } }
}

public extension Array {
    func setMap<T: Hashable>(_ transform: (Element) throws -> T) rethrows -> Set<T> {
        var set: Set<T> = []
        forEach {
            if let element = try? transform($0) { set.insert(element) }
        }
        return set
    }
    
    static func compose<T: Hashable>(from array: Set<T>, _ transform: (T) throws -> [Element]) rethrows -> [Element] {
        try array.flatMap(transform)
    }
    
    static func compose<T>(from array: [T], _ transform: (T) throws -> [Element]) rethrows -> [Element] {
        try array.flatMap(transform)
    }
    
    static func compose<T: Hashable>(from array: Set<T>, _ transform: (T) throws -> Element) rethrows -> [Element] {
        try array.compactMap(transform)
    }
    
    static func compose<T>(from array: [T], _ transform: (T) throws -> Element) rethrows -> [Element] {
        try array.compactMap(transform)
    }
}

public extension Array where Element: Hashable {
    func set() -> Set<Element> { setMap { $0 } }
}

public extension Dictionary {
    func setMap<T: Hashable>(_ transform: @escaping (Key, Value) -> T) -> Set<T> {
        var set: Set<T> = []
        self.forEach { key, value in set.insert(transform(key, value)) }
        return set
    }
    
    func compactSetMap<T: Hashable>(_ transform: @escaping (Key, Value) -> T?) -> Set<T> {
        var set: Set<T> = []
        self.forEach { key, value in
            if let element = transform(key, value) { set.insert(element) }
        }
        return set
    }
}

public extension Set where Element: Encodable {
    func data(with encoder: JSONEncoder) throws -> Data {
        try encoder.encode(self)
    }
}

public extension Array where Element: Decodable {
    init(from data: Data?, with decoder: JSONDecoder) throws {
        guard let data = data else {
            self.init()
            return
        }
        self = try decoder.decode(Self.self, from: data)
    }
}

public extension Set where Element: Decodable {
    init(from data: Data?, with decoder: JSONDecoder) throws {
        guard let data = data else {
            self.init()
            return
        }
        self = try decoder.decode(Self.self, from: data)
    }
}
