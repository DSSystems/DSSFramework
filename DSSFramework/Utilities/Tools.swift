//
//  Tools.swift
//  DSSFramework
//
//  Created by David on 16/02/21.
//  Copyright © 2021 DS_Systems. All rights reserved.
//

import Foundation

extension Data {
    public func size() -> (value: Float, unit: String) {
        let bcf = ByteCountFormatter()
        bcf.countStyle = .file
        bcf.allowedUnits = [.useKB]
        let size = bcf.string(fromByteCount: Int64(count))
            .replacingOccurrences(of: String(Locale.current.groupingSeparator ?? ""), with: "")
            .split(separator: " ")
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = .current
        numberFormatter.groupingSeparator = Locale.current.groupingSeparator
        guard let valueString = size.first,
              let value = numberFormatter.number(from: String(valueString)),
              let unit = size.last
        else {
            return (value: -1, unit: String(size.last ?? "N/A"))
        }
        
        return (value: value.floatValue, unit: String(unit))
    }
}

public func setter<O: AnyObject, V>(for object: O, _ keyPath: ReferenceWritableKeyPath<O, V>) -> (V) -> Void {
    { [weak object] value in object?[keyPath: keyPath] = value }
}

public func setter<O: AnyObject, V>(
    for object: O,
    default defaultValue: V,
    _ keyPath: ReferenceWritableKeyPath<O, V>
) -> (V?) -> Void {
    { [weak object] value in object?[keyPath: keyPath] = value ?? defaultValue }
}

public func setter<O: AnyObject, V>(for object: O?, _ keyPath: ReferenceWritableKeyPath<O, V>) -> (V) -> Void {
    { [weak object] value in object?[keyPath: keyPath] = value }
}

public func getter<O: AnyObject, V>(from object: O, _ keyPath: ReferenceWritableKeyPath<O, V?>) -> () -> V? {
    { [weak object] in object?[keyPath: keyPath] }
}

public func getter<O: AnyObject, V>(from object: O?, _ keyPath: ReferenceWritableKeyPath<O, V?>) -> () -> V? {
    { [weak object] in object?[keyPath: keyPath] }
}

public func getter<O: AnyObject, V>(from object: O, _ keyPath: ReferenceWritableKeyPath<O, V>) -> () -> V? {
    { [weak object] in object?[keyPath: keyPath] }
}

public func getter<O: AnyObject, V>(from object: O, default defaulValue: V, _ keyPath: ReferenceWritableKeyPath<O, V>) -> () -> V {
    { [weak object] in object?[keyPath: keyPath] ?? defaulValue }
}

public func optional<T>(_ block: @escaping () -> T) -> () -> T? {
    { .some(block()) }
}

public extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}

public typealias Predicate<Element> = (Element) -> Bool

public func == <Element, Property: Comparable>(lhs: KeyPath<Element, Property>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] == rhs }
}

public func == <Element, Property: Comparable>(lhs: KeyPath<Element, Property?>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] == rhs }
}

public func != <Element, Property: Comparable>(lhs: KeyPath<Element, Property>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] != rhs }
}

public func != <Element, Property: Comparable>(lhs: KeyPath<Element, Property?>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] != rhs }
}

public func > <Element, Property: Comparable>(lhs: KeyPath<Element, Property>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] > rhs }
}

public func > <Element, Property: Comparable>(lhs: KeyPath<Element, Property?>, rhs: Property) -> Predicate<Element> {
    {
        guard let lhsValue = $0[keyPath: lhs] else { return false }
        return lhsValue  > rhs
    }
}

public func >= <Element, Property: Comparable>(lhs: KeyPath<Element, Property>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] >= rhs }
}

public func < <Element, Property: Comparable>(lhs: KeyPath<Element, Property>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] < rhs }
}

public func <= <Element, Property: Comparable>(lhs: KeyPath<Element, Property>, rhs: Property) -> Predicate<Element> {
    { $0[keyPath: lhs] <= rhs }
}

public func > <Element, Property: Comparable>(
    lhs: KeyPath<Element, Property>,
    rhs: KeyPath<Element, Property>
) -> (Element, Element) -> Bool  {
    { element1, elemenr2 in
        element1[keyPath: lhs] > element1[keyPath: rhs]
    }
}

public func >= <Element, Property: Comparable>(
    lhs: KeyPath<Element, Property>,
    rhs: KeyPath<Element, Property>
) -> (Element, Element) -> Bool  {
    { element1, elemenr2 in
        element1[keyPath: lhs] >= element1[keyPath: rhs]
    }
}

public func < <Element, Property: Comparable>(
    lhs: KeyPath<Element, Property>,
    rhs: KeyPath<Element, Property>
) -> (Element, Element) -> Bool  {
    { element1, elemenr2 in
        element1[keyPath: lhs] < element1[keyPath: rhs]
    }
}

public func <= <Element, Property: Comparable>(
    lhs: KeyPath<Element, Property>,
    rhs: KeyPath<Element, Property>
) -> (Element, Element) -> Bool  {
    { element1, elemenr2 in
        element1[keyPath: lhs] <= element1[keyPath: rhs]
    }
}

extension Array {
    public func map<T>(_ keypath: KeyPath<Element, T>) -> Array<T> {
        map { element in element[keyPath: keypath] }
    }
}
