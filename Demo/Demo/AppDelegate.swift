//
//  AppDelegate.swift
//  SplashWindow-Example
//
//  Created by Hao Zheng on 4/30/17.
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
        let splashWindow = SplashWindow.init(window: self.window!, launchViewController: vc)
        
        /** Customization - otherwise default
         
            AppAuthentication.shared.touchIDMessage = "YOUR MESSAGE"
            splashWindow.touchIDBtnImage = UIImage(named: "user.png")
            splashWindow.logoutBtnImage = UIImage(named: "user.png")
         */
        
        //Auth succeeded closure
        splashWindow.authSucceededClosure = { _ in }
        
        //Return a loginVC after clicking logout
        splashWindow.logoutClosure = { 
            return UIStoryboard.named("Login", vc: "LoginViewController")
        }
        return splashWindow
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let initialVC = UINavigationController(rootViewController: AuthFlowController().authSettingVC)
        /*
         Use your logic to determine whether your app is loggedIn
         initialVC can be any of your viewController, but must make sure if it's loggedIn when showing this VC
         */
        splashWindow.authenticateUser(isLoggedIn: true, initialVC: initialVC)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        splashWindow.showSplashView()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        splashWindow.enteredBackground()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        /*
         Use your logic to determine whether your app is loggedIn
         
         If you already have some code here in didBecomeActive such as refreshing
         network request or load data from database, if you want to bypass
         these actions before authentication, use self.splashWindow.isAuthenticating:
         
         //1. call authenticateUser first
         splashWindow.authenticateUser(isLoggedIn: true)
         
         //2. if you are authenticating, here it skips YOUR NETWORK CODE or DATABASE CODE
         guard !splashWindow.isAuthenticating else { return }
         
         //...
         //YOUR NETWORK CODE or DATABASE CODE
         //...
         
         */
        
        let rootIsLoginVC = window?.rootViewController is LoginViewController
        splashWindow.authenticateUser(isLoggedIn: !rootIsLoginVC)
    }
}
