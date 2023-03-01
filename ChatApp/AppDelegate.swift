//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Станислава on 22.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var state = "Not Running"
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Logger.shared.printLog(log: "Application moved from \(state) to Inactive: \(#function)")
        state = "Inactive"
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        Logger.shared.printLog(log: #function)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Logger.shared.printLog(log: "Application moved from \(state) to Inactive: \(#function)")
        state = "Inactive"
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Logger.shared.printLog(log: "Application moved from \(state) to Active: \(#function)")
        state = "Active"
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Logger.shared.printLog(log: "Application moved from \(state) to Background: \(#function)")
        state = "Background"
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Logger.shared.printLog(log: "Application moved from \(state) to Inactive: \(#function)")
        state = "Inactive"
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        Logger.shared.printLog(log: "Application moved from \(state) to Not Running: \(#function)")
        state = "Not Running"
    }
}



