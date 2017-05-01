
import UIKit

enum AuthSettingsItem {
    case passcode(AuthTableRow)
    case touchID(AuthTableRow)
}

extension AuthSettingsItem {
    
    static let switchCellID = String(describing: SharedSwitchTableViewCell.self)
    
    var cellDescriptor: TableCellDescriptor {
        switch self {
        case .passcode(let passcode):
            return TableCellDescriptor(reuseIdentifier: AuthSettingsItem.switchCellID, configure: passcode.configureCell)
        case .touchID(let touchID):
            return TableCellDescriptor(reuseIdentifier: AuthSettingsItem.switchCellID, configure: touchID.configureCell)
        }
    }
}

struct AuthTableRow {
    
    weak var delegate: SharedSwitchTableViewCellDelegate?
    
    let title: String?
    let isOn: Bool
    let enabled: Bool

    init(_ delegate: SharedSwitchTableViewCellDelegate?,
         _ title: String?,
         _ isOn: Bool,
         _ enabled: Bool = false) {
        self.delegate = delegate
        self.title = title
        self.isOn = isOn
        self.enabled = enabled
    }
    
    func configureCell(_ cell: SharedSwitchTableViewCell) {
        cell.delegate = delegate
        cell.leftLabel.text = title
        cell.switchControl.isEnabled = enabled
        cell.switchControl.isOn = enabled ? isOn : false
    }
}
