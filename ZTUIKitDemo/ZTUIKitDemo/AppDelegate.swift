//
//  AppDelegate.swift
//  ZTUIKitDemo
//
//  Created by trojan on 2024/6/4.
//

import UIKit
import ZTChain

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
            .zt
            .backgroundColor(.white)
            .rootViewController(ViewController())
            .subject
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

