
import UIKit

protocol SharedSwitchTableViewCellDelegate: class {
    func didToggleSwitch(_ sender: AnyObject)
}

class SharedSwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    weak var delegate: SharedSwitchTableViewCellDelegate?
    
    @IBAction func toggleSwitch(_ sender: AnyObject) {
        delegate?.didToggleSwitch(sender)
    }
}
