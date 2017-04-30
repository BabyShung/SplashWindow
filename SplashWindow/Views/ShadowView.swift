
import UIKit

public class ShadowView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 2.5 {
        didSet {
            updateProperties()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            updateProperties()
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        updateProperties()
        updateShadowPath()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }
    
    fileprivate func updateProperties() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
    }
    
    fileprivate func updateShadowPath() {
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }
}


