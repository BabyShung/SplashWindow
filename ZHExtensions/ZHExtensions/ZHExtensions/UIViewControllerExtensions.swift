
import UIKit

public extension UIViewController {
    /// Present UIActivityViewController
    ///
    /// - Parameters:
    ///   - activityItems: any item
    ///   - sender: iPad only, the control you click to present
    public func presentUIActivityViewController(activityItems: [Any], sender: AnyObject? = nil) {
        
        let activity = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        // will populate with any possible activity types (e.g. facebook, twitter, etc.)
        activity.excludedActivityTypes = []
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            guard let sender = sender else { return }
            presentPopover(with: activity, sender: sender)
        default:
            present(activity, animated: true, completion: nil)
        }
    }
}

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
    public func presentPopover(with vc: UIViewController, sender: AnyObject) {
        vc.modalPresentationStyle = .popover
        let container = vc.popoverPresentationController
        container?.sourceView = sender as? UIView
        container?.sourceRect = sender.bounds
        container?.delegate = self
        present(vc, animated: true) {
            container?.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

