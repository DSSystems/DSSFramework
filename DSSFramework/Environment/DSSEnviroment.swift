//
//  DSSEnviroment.swift
//  DSSFramework
//
//  Created by David on 09/11/19.
//  Copyright © 2019 DS_Systems. All rights reserved.
//

import UIKit

public enum AppEnviroment {
    case debug, production
    
    private static let _status: AppEnviroment = {
        var env: AppEnviroment = .production
        #if DEBUG
        env = .debug
        #endif
        return env
    }()
    
    public static func status() -> AppEnviroment {
        return _status
    }
}

public struct AppInfo {
    
    // MARK: - Properties
    
    private let bundle: Bundle
    public let name: String
    public let version: String
    public let build: String
    
    // MARK: - init
    
    public init(bundle: Bundle) {
        self.bundle = bundle
        let appInfoDictionary = bundle.infoDictionary
        self.name = (appInfoDictionary?[kCFBundleNameKey as String] as? String) ?? "Unknown"
        self.build = (appInfoDictionary?[kCFBundleVersionKey as String] as? String) ?? "N/A"
        self.version = (appInfoDictionary?["CFBundleShortVersionString"] as? String) ?? "N/A"
    }
}



public struct AppTheme {
    
    // MARK: - Properties
    
    public let primary: DSSColor
    public let secondary: DSSColor
    public let destructive: DSSColor
    public let text: DSSColor
    public let placeholder: DSSColor
    public let background: DSSColor
    
    public let transitionDuration: TimeInterval
    
    // MARK: - init
    
    public init(primary: DSSColor,
                secondary: DSSColor,
                destructive: DSSColor = .fixedColor(.red),
                text: DSSColor = .init(light: .black, dark: .white),
                placeholder: DSSColor = .init(light: .darkGray, dark: .lightGray),
                background: DSSColor = .init(light: .white, dark: .black),
                transitionDuration: TimeInterval = 0.2) {
        
        self.primary = primary
        self.secondary = secondary
        self.destructive = destructive
        self.text = text
        self.placeholder = placeholder
        self.background = background
        self.transitionDuration = transitionDuration
    }
}

public struct AppTiming {
    
    // MARK: - Properties
    
    public let short: TimeInterval
    public let basic: TimeInterval
    public let medium: TimeInterval
    public let large: TimeInterval
    
    // MARK: - init
    
    public init(short: TimeInterval = 0.1,
                basic: TimeInterval = 0.3,
                medium: TimeInterval = 0.5,
                large: TimeInterval = 1.0) {
        self.short = short
        self.basic = basic
        self.medium = medium
        self.large = large
    }
}

public struct AppFont {
    // MARK: - Properties
    
    public let huge: UIFont
    public let hugeBold: UIFont
    public let large: UIFont
    public let largeBold: UIFont
    public let title: UIFont
    public let titleBold: UIFont
    public let regular: UIFont
    public let regularBold: UIFont
    public let small: UIFont
    public let smallBold: UIFont
    public let tiny: UIFont
    public let tinyBold: UIFont
    
    // MARK: - Init
    
    public init(huge: UIFont = .systemFont(ofSize: 26),
                large: UIFont = .systemFont(ofSize: 20),
                title: UIFont = .systemFont(ofSize: 16),
                regular: UIFont = .systemFont(ofSize: 14),
                small: UIFont = .systemFont(ofSize: 12),
                tiny: UIFont = .systemFont(ofSize: 9)) {
        self.huge = huge
        self.hugeBold = .boldSystemFont(ofSize: huge.lineHeight)
        self.large = large
        self.largeBold = .boldSystemFont(ofSize: large.lineHeight)
        self.title = title
        self.titleBold = .boldSystemFont(ofSize: title.lineHeight)
        self.regular = regular
        self.regularBold = .boldSystemFont(ofSize: regular.lineHeight)
        self.small = small
        self.smallBold = .boldSystemFont(ofSize: small.lineHeight)
        self.tiny = tiny
        self.tinyBold = .boldSystemFont(ofSize: tiny.lineHeight)
    }
    
    public init(regular: UIFont, fontSize: CGFloat = 14) {
        self.huge = regular.withSize(12 + fontSize)
        self.hugeBold = regular.withSize(12 + fontSize).bold
        self.large = regular.withSize(6 + fontSize)
        self.largeBold = regular.withSize(6 + fontSize).bold
        self.title = regular.withSize(2 + fontSize)
        self.titleBold = regular.withSize(2 + fontSize).bold
        self.regular = regular.withSize(fontSize)
        self.regularBold = regular.bold
        self.small = regular.withSize(fontSize - 2)
        self.smallBold = regular.withSize(fontSize - 2).bold
        self.tiny = regular.withSize(fontSize - 3)
        self.tinyBold = regular.withSize(fontSize - 3).bold
    }
    
    // MARK: - Handlers
}

public protocol DSSEnviroment {
    // MARK: - Static properties
    
    static var theme: AppTheme { get }
    static var info: AppInfo { get }
    static var fonts: AppFont { get }
    static var timing: AppTiming { get }
}

public extension DSSEnviroment {
    static var appEnviroment: AppEnviroment { .status() }
}
