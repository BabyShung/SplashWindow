
import UIKit

public extension UICollectionView {
    
    public func dequeue<T: UICollectionViewCell>(_ indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            fatalError("Can't instantiate VC with identifier \(T.cellIdentifier) ")
        }
        return cell
    }
    
    public func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    public func registerNib<T: UICollectionViewCell>(_:T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeue<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}

public protocol CollectionViewCellIdentifiable {
    static var cellIdentifier: String { get }
}

public extension CollectionViewCellIdentifiable where Self: UICollectionViewCell {
    public static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell : CollectionViewCellIdentifiable { }
