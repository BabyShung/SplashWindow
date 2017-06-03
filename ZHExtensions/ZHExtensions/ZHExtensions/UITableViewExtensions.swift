
import UIKit

public extension UITableView {
    
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    public func registerNib<T: UITableViewCell>(_:T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeue<T: UITableViewCell>(_: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T ?? T()
    }
}
