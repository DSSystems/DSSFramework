//
//  WeakRef.swift
//  DSSFramework
//
//  Created by David on 26/05/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation

public final class WeakRef<Object: AnyObject> {
    public private(set) weak var object: Object?
    
    public init(_ object: Object) { self.object = object }    
}

public final class WeakRefs<Object: AnyObject> {
    public private(set) var objects: [WeakRef<Object>]
    
    public init(_ objects: Object...) {
        self.objects = objects.map(WeakRef.init)
    }
}

public protocol Weakifiable: AnyObject {}

extension NSObject: Weakifiable {}

public extension Weakifiable {
    func weakify<P, R>(default defaultValue: R, _ block: @escaping (Self, P) -> R) -> (P) -> R {
        return { [weak self] param in
            guard let self = self else { return defaultValue }
            return block(self, param)
        }
    }
    
    func weakify<R>(default defaultValue: R, _ block: @escaping (Self) -> R) -> () -> R {
        return { [weak self] in
            guard let self = self else { return defaultValue }
            return block(self)
        }
    }
    
    func weakify<P, R>(_ block: @escaping (Self, P) -> R?) -> (P) -> R? {
        return { [weak self] param in
            guard let self = self else { return nil }
            return block(self, param)
        }
    }
    
    func weakify<P>(_ block: @escaping (Self, P) -> Void) -> (P) -> Void {
        return { [weak self] param in
            guard let self = self else { return }
            block(self, param)
        }
    }
    
    func weakify<T>(_ block: @escaping (Self) -> T?) -> () -> T? {
        return { [weak self] in
            guard let self = self else { return nil }
            return block(self)
        }
    }
    
    func weakify(_ block: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            block(self)
        }
    }
}

public func compose<T>(_ outputs: [(T) -> Void]) -> (T) -> Void {
    return { value in outputs.forEach { $0(value) } }
}
