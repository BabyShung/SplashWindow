
import Foundation
import LocalAuthentication
import UIKit
import ZHExtensions

public class AppAuthentication {
    
    public static let shared = AppAuthentication()
    
    //MARK: static vars
    public var storage: SWStorage {
        return UserDefaults.standard
    }
    
    /// Whether your touchID or passcode is on
    public var authEnabled: Bool {
        return passcodeEnabled || touchIDEnabled
    }
    
    /// Whether your passcode is on
    public var passcodeEnabled: Bool {
        //fix this if you set your own passcodeView
        return false //storage.passcodeEnabled()
    }
    
    /// Whether your device supports touchID
    public var touchIDEnabledOnDevice: Bool {
        return LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    /// Whether your touchID is on
    public var touchIDEnabled: Bool {
        let deviceTouchIDEnabled = self.touchIDEnabledOnDevice
        guard deviceTouchIDEnabled else { return false }
        
        //turn on touchID by default if device supports touchID
        if storage.touchIDObjectInStorage() == nil {
            storage.setTouchID(true)
        }
        return storage.touchIDEnabled() && deviceTouchIDEnabled
    }
    
    //MARK: Setters
    
    /// Set passcode by a string (passcodeView not implemented)
    public func setPasscode(passcode: String) {
        storage.setPasscode(passcode)
    }
    
    /// Turn on or off touchID in your app
    public func setTouchID(enabled: Bool) {
        storage.setTouchID(enabled)
    }
    
    //MARK: authenticate
    public func authenticateUser(handler: @escaping (Bool, NSError?) -> ()) {
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
    
    public func cleanupAllSettings() {
        storage.removeAllInfo()
    }
}

/*
 Lower level of AppAuthentication
 */
public protocol SWStorage {
    func passcodeEnabled() -> Bool
    func setPasscode(_ passcode: String)
    func touchIDEnabled() -> Bool
    func touchIDObjectInStorage() -> Bool?
    func setTouchID(_ enable: Bool)
    func removeAllInfo()
}

extension UserDefaults: SWStorage {
    
    public func passcodeEnabled() -> Bool {
        return Defaults[.passcode] != nil
    }
    
    public func setPasscode(_ passcode: String) {
        Defaults[.passcode] = passcode
    }
    
    public func touchIDEnabled() -> Bool {
        guard let enabled = touchIDObjectInStorage() else { return false }
        return enabled
    }
    
    public func touchIDObjectInStorage() -> Bool? {
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
