
import Foundation
import UIKit

public class AlertViews {
    class func show(title: String?, msg: String?, okTitle: String?) {
        let alertView = UIAlertController(title: title,
                                          message: msg,
                                          preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: okTitle,
                                          style: .default,
                                          handler: nil))
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(alertView, animated: true, completion: nil)
    }
}

