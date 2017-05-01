//
//  AppDelegate.swift
//  SplashWindow-Example
//
//  Created by Hoa Zheng on 4/30/17.
//  Copyright © 2017 Hao Zheng. All rights reserved.
//

import UIKit
import SplashWindow

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var splashWindow: SplashWindow = {
        let identifier = "LaunchScreen"
        let vc = UIStoryboard.named(identifier, vc: identifier)
        return SplashWindow.init(window: self.window!, launchViewController: vc, success: { authType in
            //auth succeeded closure
        }, logout: { _ in
            //return a loginVC after clicking logout
            return UIStoryboard.named("Login", vc: "LoginViewController")
        })
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let initialVC = UINavigationController(rootViewController: AuthFlowController().authSettingVC)
        splashWindow.authenticateUser(initialVC: initialVC)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        splashWindow.showSplashView()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        splashWindow.enteredBackground()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        splashWindow.authenticateUser()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

