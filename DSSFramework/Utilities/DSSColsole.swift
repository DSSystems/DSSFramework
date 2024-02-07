//
//  DSSColsole.swift
//  DSSFramework
//
//  Created by David on 12/05/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit

open class DSSConsole {
    public enum Enviroment: String {
        case local, remote
    }
    
    static var remoteConsoles: Set<URL> = []
    
    public static var logSchemes: Set<Enviroment> = [.local]
    
    public class func addRemote(_ urlString: String) {
        guard let url = urlString.url else { return }
        remoteConsoles.insert(url)
    }
    
    public class func log<T: Error>(error: T, localizedDescription: String, sender: Any) {
        log(bundle: .main, error: error, localizedDescription: localizedDescription, sender: sender)
    }
    
    public class func log<T: Error>(bundle: Bundle, error: T, localizedDescription: String, sender: Any) {
        if logSchemes.contains(.local) {
            #if DEBUG
            print("[\(String(describing: sender))] Error (\(Date())): \(localizedDescription)\n\(error)")
            #endif
        }
        
        if logSchemes.contains(.remote) {
            remoteLog(bundle: bundle, error: error, localizedDescription: localizedDescription, sender: sender)
        }
    }
    
    public class func log(message: String, sender: Any) {
        if logSchemes.contains(.local) {
            #if DEBUG
            print("[\(String(describing: sender))] Error (\(Date())): \(message)")
            #endif
        }
        
//        if logSchemes.contains(.remote) {
//            remoteLog(bundle: bundle, error: error, localizedDescription: localizedDescription, sender: sender)
//        }
    }
    
    class private func remoteLog<T: Error>(
        bundle: Bundle,
        error: T,
        localizedDescription: String,
        sender: Any
    ) {
        let time = Date()
        
        let bodyString = "time=\(time.description)&bundle=\(bundle.bundleIdentifier ?? "NONE")&context=\(String(reflecting: sender))&localized_description=\(localizedDescription)&debug_description=\((error as NSError).debugDescription)&error=\(error)"
        guard let data = bodyString.data(using: .utf8) else { return }
        
        remoteConsoles.forEach {
            var request = URLRequest(url: $0)
            request.httpBody = data
            request.httpMethod = "POST"
            let task = URLSession.shared.dataTask(with: request)
            task.resume()
        }
    }
    
    class public func alert(description: String) {
        guard let topViewController = UIApplication.shared.topViewController() else { return }
        
        let alertController = UIAlertController(title: "Under development",
                                                message: description,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak alertController] (_) in
            alertController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action)
        
        topViewController.present(alertController, animated: true, completion: nil)
    }
}
