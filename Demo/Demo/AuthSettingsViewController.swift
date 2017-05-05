
import UIKit
import SplashWindow

class AuthSettingsViewController: GenericTableViewController<AuthSettingsItem> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AuthStrings.settings
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.hexStringToUIColor(hex: "#EFF0F1")
    }
}

extension AuthSettingsViewController: SharedSwitchTableViewCellDelegate {
    func didToggleSwitch(_ sender: AnyObject) {
        let switchControl = sender as! UISwitch
        AppAuthentication.setTouchID(enabled: switchControl.isOn)
    }
}
