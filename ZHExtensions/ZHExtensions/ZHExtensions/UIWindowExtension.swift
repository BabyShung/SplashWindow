
import UIKit

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
