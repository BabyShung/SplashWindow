
import Foundation
import UIKit
import LocalAuthentication

public class SplashWindow: UIWindow {
    
    //Public
    fileprivate(set) var isAuthenticating: Bool = false
    
    //private
    fileprivate unowned var protectedWindow: UIWindow
    fileprivate var success: (PasscodeTouchIDAuth) -> ()
    fileprivate var logout: () -> () = { _ in }
    fileprivate var initialVC: UIViewController?
    fileprivate var authenticateFromTouchID = false
    fileprivate var didEnterBackground: Bool = true
    lazy fileprivate var transition: CATransition = {
        let transition = CATransition()
        transition.duration = 0.2
        transition.type = kCATransitionFade
        return transition
    } ()
    lazy fileprivate var optionVC: OptionsViewController = {
        
        let sb = UIStoryboard(name: String(describing: SplashWindow.self), bundle: Bundle(identifier: "com.Planhola.SplashWindow"))
        
        let optionVC = sb.instantiateViewController(withIdentifier: String(describing: OptionsViewController.self)) as! OptionsViewController
        optionVC.modalPresentationStyle = .overCurrentContext
        optionVC.modalTransitionStyle = .crossDissolve
        return optionVC
    }()
    
    
    /**
     Depends on where your launch screen lives
     - launchScreen in a xib
     - launchScreen in a storyboard
     */
    public convenience init(window: UIWindow,
                     launchXibName: String,
                     success: @escaping (PasscodeTouchIDAuth) -> (),
                     logout: @escaping () -> ()) {
        let dummyVC = UIViewController()
        dummyVC.view.isHidden = true
        self.init(window: window,
                  launchViewController: dummyVC,
                  success: success,
                  logout: logout)
        guard let splashView = Bundle.main.loadNibNamed(launchXibName, owner: nil, options: nil)?.first as? UIView else { return }
        splashView.constraintEdges(to: self)
    }
    
    public init(window: UIWindow,
         launchViewController: UIViewController,
         success: @escaping (PasscodeTouchIDAuth) -> (),
         logout: @escaping () -> ()) {
        self.protectedWindow = window
        self.success = success
        self.logout = logout
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
    
    func authenticateUser(initialVC: UIViewController? = nil) {
        
        guard !isAuthenticating else {
            return
        }
        guard !authenticateFromTouchID else {
            authenticateFromTouchID = false
            return
        }
        if let initialVC = self.initialVC {
            protectedWindow.transitionRootTo(initialVC) { _ in
                self.showSelf(show: false, animated: true)
            }
            self.initialVC = nil
            return
        }
        
        var shouldVerify = false
        if didEnterBackground {
            shouldVerify = showPasscodeTouchIDIfNeeded()
            didEnterBackground = false
        }
        
        if let initialVC = initialVC {
            if shouldVerify {
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
    
    fileprivate func showPasscodeTouchIDIfNeeded() -> Bool {
        let shouldVerify = AppAuthentication.passcodeOrTouchIDEnabled
        showSelf(show: true, animated: false)
        isAuthenticating = true
        AppAuthentication.touchIDEnabled ? showTouchID() : showOptionView()
        return shouldVerify
    }
    
    fileprivate func authenticationSucceeded(type: PasscodeTouchIDAuth) {
        isAuthenticating = false
        
        /*
         Manually trigger didBecomeActive since:
         1.touchID dismiss with have a significant delay
         2.if you have a passcode view, it won't call didBecomeActive
         */
        App.delegate.applicationDidBecomeActive?(App.shared)
        
        switch type {
        case .touchIDAuth:
            authenticateFromTouchID = true
        default:
            break
        }
        success(type)
    }
    
    fileprivate func showTouchID() {
        AppAuthentication.authenticateUser { [unowned self] (success, error) in
            if success {
                self.authenticationSucceeded(type: .touchIDAuth)
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
            self.showOptionView()
        }
    }
    
    private func cleanup() {
        self.isAuthenticating = false
        self.initialVC = nil
        
        AppAuthentication.storage.removeAllInfo()
        self.showSelf(show: false, animated: true, animations: { _ in }) { [unowned self] _ in
            self.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }
    
    fileprivate func showOptionView() {
        
        optionVC.didClicklogout = { [unowned self] in
            self.logout()
            self.cleanup()
        }
        optionVC.didClickTouchID = { [unowned self] _ in
            self.rootViewController?.dismiss(animated: true, completion: nil)
            self.showTouchID()
        }
        
        self.layer.add(transition, forKey: nil) //cross dissolve
        rootViewController?.present(optionVC, animated: false, completion: nil)
    }
}

public enum PasscodeTouchIDAuth: Int {
    case passcodeAuth
    case touchIDAuth
}

public extension UIWindow {
    func transitionRootTo(_ vc: UIViewController) {
        transitionRootTo(vc, completion: { _ in })
    }
    
    func transitionRootTo(_ vc: UIViewController,
                          completion: @escaping (Bool) -> ()) {
        UIView.transition(with: self,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { 
                            UIView.setAnimationsEnabled(false)
                            self.rootViewController = vc
                            UIView.setAnimationsEnabled(true)
        }, completion: completion)
    }
}

public class App {
    static var shared = UIApplication.shared
    static var delegate = App.shared.delegate!
}


