
import UIKit
import SplashWindow

class AuthFlowController {
    
    weak var presentingVC: UIViewController?
    
    init(_ presentingVC: UIViewController? = nil) {
        self.presentingVC = presentingVC
    }
    
    var authSettingVC: AuthSettingsViewController {
        let authVC = AuthSettingsViewController.init(items: [],
                                                     cellDescriptor:{ $0.cellDescriptor })
        //section1
        let section1 = [AuthSettingsItem.touchID(
            AuthTableRow(authVC,
                         AuthStrings.enableTouchID,
                         AppAuthentication.shared.touchIDEnabled,
                         AppAuthentication.shared.touchIDEnabledOnDevice))]
        let section1Header = AuthStrings.touchID
        
        //section2
        let section2 = [AuthSettingsItem.passcode(
            AuthTableRow(authVC,
                         AuthStrings.passcode,
                         false))]
        let section2Header = AuthStrings.enablePasscode
        
        authVC.items = [section1, section2]
        authVC.headerTitles = [section1Header, section2Header]
        return authVC
    }
    
    func showAuthSetting() {
        let nVC = UINavigationController(rootViewController: authSettingVC)
        presentingVC?.present(nVC, animated: true, completion: nil)
    }
}
