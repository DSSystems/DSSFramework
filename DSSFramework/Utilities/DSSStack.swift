//
//  DSSStack.swift
//  DSSFramework
//
//  Created by David on 07/01/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation

class DSSNode<T> {
    let object: T
    var next: DSSNode<T>? = nil
    
    init(_ object: T) {
        self.object = object
    }    
}

public final class DSSStack<T> {
    public typealias Element = T
    
    var top: DSSNode<T>?
    
    public init() { }
    
    public func push(_ object: T) {
        let newNode: DSSNode<T> = .init(object)
        newNode.next = top
        top = newNode
    }
    
    public func pop() -> T? {
        defer { top = top?.next }
        
        return top?.object
    }
        
    public func peek() -> T? {
        return top?.object
    }
}
