
import UIKit

extension UIButton {
    func centerVertically(padding: CGFloat = 2.0) {
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        let imageSize = imageView.frame.size
        let titleSize = titleLabel.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height),
                                           0,
                                           0,
                                           -titleSize.width)
        titleEdgeInsets = UIEdgeInsetsMake(0,
                                           -imageSize.width,
                                           -(totalHeight - titleSize.height),
                                           0)
        contentEdgeInsets = UIEdgeInsetsMake(0,
                                             0,
                                             0,
                                             0)
    }
}
