
import UIKit

public class ShadowButton: UIButton {
    
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
    
    fileprivate var mainLayer = CAShapeLayer()
    fileprivate var animationGroup = CAAnimationGroup()
    @IBInspectable public var pulseColor: UIColor = UIColor.gray
    @IBInspectable public var pulseRadius: CGFloat = 1
    @IBInspectable public var pulseDuration: CGFloat = 0.3
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        backgroundColor = .white
        updateProperties()
        updateShadowPath()
        mainLayer = createPulse()
        self.layer.addSublayer(mainLayer)
    }
    
    override public func layoutSubviews() {
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

extension ShadowButton {
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let pulse = mainLayer
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.createAnimationGroup()
            
            DispatchQueue.main.async {
                pulse.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    fileprivate func createPulse() -> CAShapeLayer {
        let pulse = CAShapeLayer()
        pulse.backgroundColor = pulseColor.cgColor
        pulse.contentsScale = UIScreen.main.scale
        pulse.bounds = self.bounds
        pulse.cornerRadius = cornerRadius
        pulse.position = CGPoint(x: frame.width/2, y: frame.height/2)
        pulse.zPosition = -2
        pulse.opacity = 0
        
        return pulse
    }
    
    fileprivate func createAnimationGroup() {
        animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
        animationGroup.duration = CFTimeInterval(pulseDuration)
    }
    
    fileprivate func createScaleAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = (pulseRadius/10) + 1.0
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return scaleAnimation
    }
    
    fileprivate func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimation.values = [0.8, 0.4, 0]
        opacityAnimation.keyTimes = [0, 0.5, 1]
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return opacityAnimation
    }
}

