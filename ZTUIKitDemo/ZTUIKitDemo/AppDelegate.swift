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
        
        UIWindow(frame: UIScreen.main.bounds).zt
            .ref(&window)
            .backgroundColor(.white)
            .rootViewController(SteviaVC())
//            .rootViewController(ViewController())
            .call {
                $0.makeKeyAndVisible()
            }
            .build()
        
        return true
    }
}

