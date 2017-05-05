
import Foundation
import UIKit
import LocalAuthentication

public class SplashWindow: UIWindow {
    
    /* PUBLIC */
    public var touchIDMessage = "" {
        didSet {
            appAuth.touchIDMessage = touchIDMessage
        }
    }
    
    public var touchIDBtnImage: UIImage? {
        didSet {
            optionVC.touchIDBtnImage = touchIDBtnImage
        }
    }
    
    public var logoutBtnImage: UIImage? {
        didSet {
            optionVC.logoutBtnBtnImage = touchIDBtnImage
        }
    }
    
    /// Closure when auth succeeded
    public var authSucceededClosure: (AuthType) -> () = { _ in }
    
    /// Closure when clicked logout btn. Expecting a returned loginVC for transition
    public var logoutClosure: () -> (UIViewController?) = { _ in return nil }
    
    /// True if self showing touchID/passcode, false if default or auth succeeded
    public fileprivate(set) var isAuthenticating: Bool = false
    
    /// App authentication class
    public unowned var appAuth = AppAuthentication.shared
    
    /* PRIVATE */
    /// App main window
    fileprivate unowned var protectedWindow: UIWindow
    
    
    /// Your initial view controller
    fileprivate var initialVC: UIViewController?
    
    /// If user authenticated from touchID, then this class manually calls didBecomeActive of app
    /// This is to bypass the delay didBecomeActive call from system level
    fileprivate var authenticateFromTouchID = false
    
    /// App did enter background: By default assuming first launch is in bg
    fileprivate var didEnterBackground: Bool = true
    
    lazy fileprivate var transition: CATransition = {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionFade
        return transition
    } ()
    
    lazy fileprivate var optionVC: OptionsViewController = {
        let sb = UIStoryboard(name: String(describing: SplashWindow.self), bundle: Bundle(for: SplashWindow.self))
        let optionVC = sb.instantiateViewController(withIdentifier: String(describing: OptionsViewController.self)) as! OptionsViewController
        optionVC.modalPresentationStyle = .overCurrentContext
        optionVC.modalTransitionStyle = .crossDissolve
        return optionVC
    }()
    
    /// If your app is using a launchScreen.xib to set the splash screen,
    /// use this initializer for your app
    /// - Parameters:
    ///   - window: main Window in appDelegate
    ///   - launchXibView: UIView from your xib file
    public convenience init(window: UIWindow, launchXibView: UIView) {
        let dummyVC = UIViewController()
        dummyVC.view.isHidden = true
        self.init(window: window, launchViewController: dummyVC)
        launchXibView.translatesAutoresizingMaskIntoConstraints = false
        launchXibView.constraintEdges(to: self)
    }
    
    /// If your app is using LaunchScreen.storyboard 
    /// which contains your launchViewController, use this initializer
    /// - Parameters:
    ///   - window: main Window in appDelegate
    ///   - launchViewController: your launchScreen viewController
    public init(window: UIWindow, launchViewController: UIViewController) {
        self.protectedWindow = window
        super.init(frame: window.frame)
        windowLevel = UIWindowLevelAlert - 1
        isHidden = true
        rootViewController = launchViewController
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Public
public extension SplashWindow {
    
    func authenticateUser(isLoggedIn: Bool,
                          initialVC: UIViewController? = nil) {
        guard !isAuthenticating else {
            didEnterBackground = false
            return
        }
        guard !authenticateFromTouchID else {
            authenticateFromTouchID = false
            return
        }
        
        /*
         if we have touchID/passcode and first launch the app, 
         we postpone initializing you initialVC until you've authenticated
         */
        if let initialVC = self.initialVC {
            protectedWindow.transitionRootTo(initialVC) { [unowned self] _ in
                self.showSelf(show: false, animated: true)
            }
            self.initialVC = nil
            return
        }
        
        if isLoggedIn && didEnterBackground {
            showPasscodeTouchIDIfNeeded()
            didEnterBackground = false
        }
        
        //if first launching the app
        if let initialVC = initialVC {
            if isLoggedIn {
                self.initialVC = initialVC
                protectedWindow.rootViewController = UIViewController() //dummy
            } else {
                protectedWindow.transitionRootTo(initialVC) { _ in
                    self.showSelf(show: false, animated: true)
                }
            }
        } else {
            guard isAuthenticating else {
                showSelf(show: false, animated: true)
                return
            }
        }
    }
    
    func showSplashView() {
        showSelf(show: true, animated: false)
    }
    
    func enteredBackground() {
        didEnterBackground = true
    }
}

//MARK: Private
extension SplashWindow {
    
    fileprivate func showPasscodeTouchIDIfNeeded() {
        guard appAuth.authEnabled else { return }
        showSelf(show: true, animated: false)
        isAuthenticating = true
        appAuth.touchIDEnabled ? showTouchID() : showOptionView()
    }
    
    fileprivate func authenticationSucceeded(type: AuthType) {
        isAuthenticating = false
        
        /*
         Manually trigger didBecomeActive since:
         1.touchID dismiss with have a significant delay
         2.if you have a passcode view, it won't call didBecomeActive
         */
        App.delegate.applicationDidBecomeActive?(App.shared)
        
        switch type {
        case .touchID:
            authenticateFromTouchID = true
        default:
            break
        }
        authSucceededClosure(type)
    }
    
    fileprivate func showTouchID() {
        appAuth.authenticateUser { [weak self] (success, error) in
            if success {
                self?.authenticationSucceeded(type: .touchID)
                return
            }
            guard let error = error else { return }
            switch error.code {
            case LAError.Code.touchIDNotEnrolled.rawValue:
                let title = AuthStrings.touchIDNotEnrolled
                let msg = AuthStrings.goToTouchIDSettings
                let okTitle = AuthStrings.ok
                AlertViews.show(title: title, msg: msg, okTitle: okTitle)
            default:
                break
            }
            self?.showOptionView()
        }
    }
    
    private func cleanup() {
        self.isAuthenticating = false
        self.initialVC = nil
        
        appAuth.cleanupAllSettings()

        //if we have a logout closure
        if let loginVC = self.logoutClosure() {
            //transition to loginVC
            protectedWindow.transitionRootTo(loginVC) { [unowned self] _ in
                //hide splash window
                self.showSelf(show: false, animated: true, animations: { _ in }) { [unowned self] _ in
                    //dismiss optionVC
                    self.rootViewController?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    fileprivate func showOptionView() {
        
        optionVC.didClicklogout = { [weak self] in
            self?.cleanup()
        }
        optionVC.didClickTouchID = { [weak self] _ in
            self?.rootViewController?.dismiss(animated: true, completion: nil)
            self?.showTouchID()
        }
        
        self.layer.add(transition, forKey: nil) //cross dissolve
        rootViewController?.present(optionVC, animated: false, completion: nil)
    }
}

public enum AuthType: Int {
    case passcode
    case touchID
}

public class App {
    static var shared = UIApplication.shared
    static var delegate = App.shared.delegate!
}
