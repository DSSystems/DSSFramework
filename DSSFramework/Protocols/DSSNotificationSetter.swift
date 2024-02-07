//
//  DSSNotificationSetter.swift
//  DSSFramework
//
//  Created by David on 24/11/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import Foundation

public typealias DSSSetter<Model> = (Model?, Any?) throws -> Model?

open class DSSSetterHandler<Model> {
    private var notificationName: Notification.Name?
    
    private let get: () -> Model?
    private let set: (Model?) -> Void
    private var setter: DSSSetter<Model> = { _, _ in nil }
    
    public init(get: @escaping () -> Model?, set: @escaping (Model?) -> Void) {
        self.get = get
        self.set = set
    }
    
    public func setupSetter(name: Notification.Name, setter: @escaping DSSSetter<Model>) {
        notificationName = name
        self.setter = setter
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handler(notification:)),
            name: name,
            object: nil
        )
    }
    
    public func removeSetter() {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        notificationName = nil
    }
    
    @objc private func handler(notification: Notification) {
        try? set(setter(get(), notification.object))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
}

public protocol DSSNotificationSetter: AnyObject {
    associatedtype Model
    
    var setterModel: Model? { get set }
    
    var setterHandler: DSSSetterHandler<Model>? { get set }
}

extension DSSNotificationSetter {
    public func removeSetter() { safeSetterHandler.removeSetter() }
    
    public func setupSetter(name: Notification.Name?, setter: DSSSetter<Model>?) {
        guard let name = name, let setter = setter else {
            return safeSetterHandler.removeSetter()
        }
        safeSetterHandler.setupSetter(name: name, setter: setter)
    }
    
    var safeSetterHandler: DSSSetterHandler<Model> {
        guard let setterHandler = setterHandler else {
            let setterHandler = DSSSetterHandler<Model>(
                get: getter(from: self, \.setterModel),
                set: setter(for: self, \.setterModel)
            )
            self.setterHandler = setterHandler
            return setterHandler
        }
        
        return setterHandler
    }
}
