
import Foundation
import UIKit

//MARK: ShowHide view
public extension UIView {
    public func showSelf(show: Bool, animated: Bool) {
        showSelf(show: show,
                 animated: animated,
                 animations: { _ in },
                 completion: { _ in })
    }
    
    public func showSelf(show: Bool,
                         animated: Bool,
                         animations: @escaping () -> (),
                         completion: @escaping (Bool) -> ()) {
        guard isHidden == show else { return }
        var alpha: CGFloat
        if show {
            isHidden = false
            alpha = 1.0
        } else {
            alpha = 0
        }
        let animationClosure = { (alpha: CGFloat) in
            animations()
            self.alpha = alpha
        }
        let completionClosure = { (finished: Bool, show: Bool) in
            if !show {
                self.isHidden = true
            }
            completion(finished)
        }
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
                animationClosure(alpha)
            }, completion: { finished in
                completionClosure(finished, show)
            })
        } else {
            animationClosure(alpha)
            completionClosure(true, show)
        }
    }
}

public extension UIView {
    func addBlurView() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.constraintEdges(to: self)
        sendSubview(toBack: blurView)
    }
    
    func addOnTopMotionEffect(relativeValue: Float = 25.0) {
        //Horizontal motion
        var motionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis);
        motionEffect.minimumRelativeValue = relativeValue;
        motionEffect.maximumRelativeValue = -relativeValue;
        addMotionEffect(motionEffect);
        
        //Vertical motion
        motionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis);
        motionEffect.minimumRelativeValue = relativeValue;
        motionEffect.maximumRelativeValue = -relativeValue;
        addMotionEffect(motionEffect);
    }
    
    func addBelowMotionEffect(relativeValue: Float = 25.0) {
        addOnTopMotionEffect(relativeValue: -relativeValue)
    }
}

//MARK: Auto Layout
public extension UIView {
    
    /**
     Pin four edges to superview
     */
    func constraintEdges(to: UIView) {
        constraintPinToTop(parent: to)
        constraintPinToLeading(parent: to)
        constraintPinToBottom(parent: to)
        constraintPinToTrailing(parent: to)
        
        /* or
         to.addSubview(self)
         self.translatesAutoresizingMaskIntoConstraints = false
         let dict = getSelfDict()
         for format in ["H:|[view]|", "V:|[view]|"] {
         to.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
         }
         */
    }
    
    func widthConstraint(width: CGFloat) {
        widthHeightConstraintHelper(value: width, isWidth: true)
    }
    
    func heightConstraint(height: CGFloat) {
        widthHeightConstraintHelper(value: height, isWidth: false)
    }
    
    func equalWidthToParent(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .width)
    }
    
    func equalHeightToParent(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .height)
    }
    
    func centerXToParent(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .centerX)
    }
    
    func centerYToParent(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .centerY)
    }
    
    func constraintPinToTop(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .top)
    }
    
    func constraintPinToLeading(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .left)
    }
    
    func constraintPinToBottom(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .bottom)
    }
    
    func constraintPinToTrailing(parent: UIView) {
        addSingleConstraintToParent(parent: parent, attr: .trailing)
    }
    
    /**
     private autolayout helpers
     */
    private func addSelfToParent(parent: UIView) {
        if isDescendant(of: parent) { return }
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
    }
    
    private func addSingleConstraintToParent(parent: UIView, attr: NSLayoutAttribute) {
        addSelfToParent(parent: parent)
        parent.addConstraint(NSLayoutConstraint.init(item: self, attribute: attr, relatedBy: .equal, toItem: parent, attribute: attr, multiplier: 1, constant: 0))
    }
    
    private func getSelfDict() -> Dictionary<String, UIView> {
        return ["view" : self]
    }
    
    private func widthHeightConstraintHelper(value: CGFloat, isWidth: Bool) {
        let dict = getSelfDict()
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: String.init(format: "%@:[view(%f)]", isWidth ? "H" : "V", value), options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
    }
    
}
