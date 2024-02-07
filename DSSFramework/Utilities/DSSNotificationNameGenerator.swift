//
//  DSSNotificationNameGenerator.swift
//  DSSFramework
//
//  Created by David on 20/03/21.
//  Copyright © 2021 DS_Systems. All rights reserved.
//

import Foundation

public protocol DSSNotificationNameGenerator where Self: RawRepresentable, Self.RawValue == String {
    associatedtype Handler
}

public extension DSSNotificationNameGenerator {
    var name: Notification.Name { .init("\(String(describing: Handler.self)).Notification.\(rawValue)") }
}

public protocol DSSNotificationHandler {
//    associatedtype NotificationEvent: DSSNotificationNameGenerator
}

public extension DSSNotificationHandler {//where NotificationEvent.Handler == Self {
    func addObserver<Event: DSSNotificationNameGenerator>(
        _ observer: Any,
        selector: Selector,
        for notification: Event
    ) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notification.name, object: nil)
    }
    
    func removeObserver<Event: DSSNotificationNameGenerator>(
        _ observer: Any,
        for notification: Event
    ) {
        NotificationCenter.default.removeObserver(observer, name: notification.name, object: nil)
    }
    
    func post<Event: DSSNotificationNameGenerator>(
        notification: Event,
        object: Any? = nil
    ) {
        NotificationCenter.default.post(name: notification.name, object: object)
    }
}
