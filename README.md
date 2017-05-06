# SplashWindow
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Swift Version](https://img.shields.io/badge/swift-3.0-orange.svg?style=flat)
[![Platform](https://img.shields.io/cocoapods/p/Typist.svg?style=flat)](https://github.com/gabek/GitYourFeedback)

## About
This is an **UIWindow-based** touchID authentication view **framework** written in **Swift**.

*Framework is designed for:*
- *You want a relatively decoupled touchID framework (Only couple with your AppDelegate and your SettingsVC)*
- *Your app is **information-sensitive** and you want **touchID automaticlly on** (A device supports and has **touchID** on)*


## Screenshots
<div>
<kbd>
<img src="https://cloud.githubusercontent.com/assets/4360870/25762430/a39135e2-31ac-11e7-968b-06d82280bee9.gif" width="200">
<img src="https://cloud.githubusercontent.com/assets/4360870/25762432/a393ee54-31ac-11e7-9222-f9dad7756f68.gif" width="200">
<img src="https://cloud.githubusercontent.com/assets/4360870/25762433/a3975d28-31ac-11e7-976c-c0e2492b7ba0.gif" width="200">
<img src="https://cloud.githubusercontent.com/assets/4360870/25762431/a393ceba-31ac-11e7-8106-ba553bdf302f.gif" width="200">
</kbd>
</div>

## Integrate framework

<kbd>
<img src="https://cloud.githubusercontent.com/assets/4360870/25774091/56166732-3257-11e7-9923-0d05c47bb385.png" width="250">
</kbd>

#### 1. **[Carthage](https://github.com/Carthage/Carthage)** - **github "BabyShung/SplashWindow"**
- install carthage 

- create Cartfile (touch Cartfile)

- add framework in Cartfile: **github "BabyShung/SplashWindow"**


- run "carthage update"

- bind frameworks in your project (add a shell script in build phase and bind the paths of frameworks)

**There is another example project using Carthage to import the framework: [https://github.com/BabyShung/UsingZHFrameworks](https://github.com/BabyShung/UsingZHFrameworks)**

#### 2. Manually configure

There is a "Demo" folder in the repo. You will find three targets, two of them are the needed frameworks. Just run the project and you can drag both SplashWindow.framework and ZHExtension.framework to your "Linked Frameworks and Libraries".


## Warnings (Please read)
- Framework supports iOS8+
- The framework **doesn't** contain a authentication settings page. There is a **"Demo" project** in the repo showing the authSettings view controller for reference. Definitely you can create your own settings view controller and just call APIs in **AppAuthentication** to turn on/off touchID
- The **only** authentication for now is **touchID** and passcode view is not implemented for simplicity
- **By default**, touchID is **turned on** once you integrate this framework
- Sometimes after you've set the launchScreen image in your storyboard or xib, the splash screen is showing a blank view when running. This is a cache issue. To fix it, clean your project. If it still doesn't work, reboot your device or reset your similator.
- Make sure "Always Embed Swift Standard Libraries" in "Build Settings" is set to Yes.

## Import and setup in your project
Once you've added the framework in your project, just go to AppDelegate.swift and do a few steps.
- import SplashWindow
- declare a SplashWindow property and pass your window, launchVC etc
- in didFinishLaunchingWithOptions, setup your initial view controller and call SplashWindow API
- in applicationWillResignActive, call showSplashView()
- in applicationDidEnterBackground, call enteredBackground()
- in applicationDidBecomeActive, call authenticateUser
- go to your launchScreen.storyboard or launchScreen.xib and set your image:
<kbd>
<img src="https://cloud.githubusercontent.com/assets/4360870/25774477/45313630-325d-11e7-9941-4ad4545778b7.png" width="800">
</kbd>

## Demo project
**There is a "Demo" project in the folder where everything is setup in AppDelegate**

**Comments are there explaining what to configure in AppDelegate (Code also attached below):**

**Once you've configured your AppDelegate, touchID should work.**

``` swift
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
        splashWindow.logoutClosure = { _ in
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
         
            splashWindow.authenticateUser(isLoggedIn: true)
            guard !splashWindow.isAuthenticating { return }
         */
        
        let rootIsLoginVC = window?.rootViewController is LoginViewController
        splashWindow.authenticateUser(isLoggedIn: !rootIsLoginVC)
    }
}
``` swift

## TODO
- Fixed some small UI issues
- Add more unit tests
- Refactor some of the code

