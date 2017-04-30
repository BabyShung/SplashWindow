
import Foundation
import LocalAuthentication
import UIKit

public class AppAuthentication {
    
    //MARK: static vars
    public static let storage: Storage = UserDefaults.standard
    
    public static var authEnabled: Bool {
        return passcodeEnabled || touchIDEnabled
    }
    
    public static var passcodeEnabled: Bool {
        //fix this if you set your own passcodeView
        return false //storage.passcodeEnabled()
    }
    
    public static var touchIDEnabledOnDevice: Bool {
        return LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    public static var touchIDEnabled: Bool {
        let deviceTouchIDEnabled = self.touchIDEnabledOnDevice
        guard deviceTouchIDEnabled else { return false }
        
        //turn on touchID by default if device supports touchID
        if storage.getTouchIDEnabled() == nil {
            storage.setTouchID(true)
        }
        return storage.touchIDEnabled() && deviceTouchIDEnabled
    }
    
    //MARK: Setters
    public class func setPasscode(passcode: String) {
        storage.setPasscode(passcode)
    }
    
    public class func setTouchID(enabled: Bool) {
        storage.setTouchID(enabled)
    }
    
    //MARK: authenticate
    public class func authenticateUser(handler: @escaping (Bool, NSError?) -> ()) {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async(execute: {
                handler(false, error)
            })
            return
        }
        
        let reason = AuthStrings.authenticateFirst
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
            DispatchQueue.main.async(execute: {
                handler(success, error as NSError?)
            })
        }
    }
}

/*
 Lower level of AppAuthentication
 */
public protocol Storage {
    func passcodeEnabled() -> Bool
    func setPasscode(_ passcode: String)
    func touchIDEnabled() -> Bool
    func getTouchIDEnabled() -> Bool?
    func setTouchID(_ enable: Bool)
    func removeAllInfo()
}

extension UserDefaults: Storage {
    
    public func passcodeEnabled() -> Bool {
        return Defaults[.passcode] != nil
    }
    
    public func setPasscode(_ passcode: String) {
        Defaults[.passcode] = passcode
    }
    
    public func touchIDEnabled() -> Bool {
        guard let enabled = getTouchIDEnabled() else { return false }
        return enabled
    }
    
    public func getTouchIDEnabled() -> Bool? {
        return Defaults[.touchIDEnabled]
    }
    
    public func setTouchID(_ enable: Bool) {
        Defaults[.touchIDEnabled] = enable
    }
    
    public func removeAllInfo() {
        Defaults[.touchIDEnabled] = nil
        Defaults[.passcode] = nil
    }
}

extension DefaultsKeys {
    static let touchIDEnabled = DefaultsKey<Bool?>("touchIDEnabled")
    static let passcode = DefaultsKey<String?>("passcode")
}
