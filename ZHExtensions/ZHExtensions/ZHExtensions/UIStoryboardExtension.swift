
import UIKit

public extension UIStoryboard {

    class func named(_ storyboardName: String, vc: String) -> UIViewController {
        let sb = UIStoryboard.init(name: storyboardName, bundle: nil)
        return sb.instantiateViewController(withIdentifier: vc)
    }
}
