//
//  DSSPhysicalQuantity.swift
//  DSSFramework
//
//  Created by David on 19/02/21.
//  Copyright © 2021 DS_Systems. All rights reserved.
//

import Foundation

public enum DSSUntiPlacement {
    case before, after
}

public protocol DSSPhysicalUnit {
    var id: Int { get }
    var symbol: String { get }
    
    init?(symbol: String)
}

public extension DSSPhysicalUnit {
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}

public protocol DSSPhysicalQuantity {
    associatedtype PhysicalUnit: DSSPhysicalUnit & Equatable
    static var formatter: NumberFormatter { get }
    static var unitPlacement: DSSUntiPlacement { get }
    static var decimals: Int { get }
    
    var value: Float { get }
    var unit: PhysicalUnit { get }
    
    init(unit: PhysicalUnit, value: Float)
}

public extension DSSPhysicalQuantity where Self: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.unit == rhs.unit) && (lhs.value == rhs.value)
    }
    
    static func != (lhs: Self, rhs: Self) -> Bool { !(lhs == rhs) }
}

public extension DSSPhysicalQuantity {
    static func > (lhs: Self, rhs: Self) -> Bool {
        (lhs.unit == rhs.unit) && (lhs.value > rhs.value)
    }
    
    static func < (lhs: Self, rhs: Self) -> Bool { !(lhs > rhs) }
    
    static func >= (lhs: Self, rhs: Self) -> Bool {
        (lhs.unit == rhs.unit) && (lhs.value >= rhs.value)
    }
    
    static func <= (lhs: Self, rhs: Self) -> Bool { !(lhs >= rhs) }
}

public extension DSSPhysicalQuantity {
    static func * (factor: Float, quantity: Self) -> Self {
        .init(unit: quantity.unit, value: factor * quantity.value)
    }
    
    static func * (factor: Int, quantity: Self) -> Self {
        .init(unit: quantity.unit, value: Float(factor) * quantity.value)
    }
    
    static func * (factor: Double, quantity: Self) -> Self {
        .init(unit: quantity.unit, value: Float(factor) * quantity.value)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(unit)\(value)")
    }
    
    static var decimals: Int { 2 }
    
    var description: String {
        guard let valueString = Self.formatter.string(from: .init(value: value)) else {
            return "-"
        }
        
        switch Self.unitPlacement {
        case .before: return "\(unit.symbol)\(valueString)"
        case .after: return "\(valueString)\(unit.symbol)"
        }
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation<T: DSSPhysicalQuantity>(_ value: T) {
        appendInterpolation(value.description)
    }
}
