//
//  AppDelegate.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, RouterProtocol {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        return route(to: .usernameInput)
    }

}

