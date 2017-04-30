
import Foundation
import LocalAuthentication
import UIKit

class AppAuthentication {
    
    //MARK: static vars
    static let storage: Storage = UserDefaults.standard
    
    static var passcodeOrTouchIDEnabled: Bool {
        return passcodeEnabled || touchIDEnabled
    }
    
    static var passcodeEnabled: Bool {
        //fix this if you set your own passcodeView
        return false //storage.passcodeEnabled()
    }
    
    static var touchIDEnabledOnDevice: Bool {
        return LAContext().canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    static var touchIDEnabled: Bool {
        let deviceTouchIDEnabled = self.touchIDEnabledOnDevice
        guard deviceTouchIDEnabled else { return false }
        
        //turn on touchID by default if device supports touchID
        if storage.getTouchIDEnabled() == nil {
            storage.setTouchID(true)
        }
        return storage.touchIDEnabled() && deviceTouchIDEnabled
    }
    
    //MARK: Setters
    class func setPasscode(passcode: String) {
        storage.setPasscode(passcode)
    }
    
    class func setTouchID(enabled: Bool) {
        storage.setTouchID(enabled)
    }
    
    //MARK: authenticate
    class func authenticateUser(handler: @escaping (Bool, NSError?) -> ()) {
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
protocol Storage {
    func passcodeEnabled() -> Bool
    func setPasscode(_ passcode: String)
    func touchIDEnabled() -> Bool
    func getTouchIDEnabled() -> Bool?
    func setTouchID(_ enable: Bool)
    func removeAllInfo()
}

extension UserDefaults: Storage {
    
    func passcodeEnabled() -> Bool {
        return Defaults[.passcode] != nil
    }
    
    func setPasscode(_ passcode: String) {
        Defaults[.passcode] = passcode
    }
    
    func touchIDEnabled() -> Bool {
        guard let enabled = getTouchIDEnabled() else { return false }
        return enabled
    }
    
    func getTouchIDEnabled() -> Bool? {
        return Defaults[.touchIDEnabled]
    }
    
    func setTouchID(_ enable: Bool) {
        Defaults[.touchIDEnabled] = enable
    }
    
    func removeAllInfo() {
        Defaults[.touchIDEnabled] = nil
        Defaults[.passcode] = nil
    }
}

extension DefaultsKeys {
    static let touchIDEnabled = DefaultsKey<Bool?>("touchIDEnabled")
    static let passcode = DefaultsKey<String?>("passcode")
}
