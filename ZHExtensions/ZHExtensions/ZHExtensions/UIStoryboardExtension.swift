
import UIKit

public extension UIStoryboard {
    
    public func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Can't instantiate VC with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

public extension StoryboardIdentifiable where Self: UIViewController {
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController : StoryboardIdentifiable { }

public extension UIStoryboard {

    class func named(_ storyboardName: String, vc: String) -> UIViewController {
        let sb = UIStoryboard.init(name: storyboardName, bundle: nil)
        return sb.instantiateViewController(withIdentifier: vc)
    }
}
