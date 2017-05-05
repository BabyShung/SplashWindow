
import UIKit

public extension NSAttributedString {
    
    /// Set indentation (left padding) of self
    ///
    /// - Parameters:
    ///   - text: text
    ///   - val: padding value
    /// - Returns: new attributed string
    class func indentString(text: String, val: CGFloat) -> NSAttributedString {
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = .justified
        style.firstLineHeadIndent = val
        style.headIndent = val
        style.tailIndent = -val
        return NSAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: style])
    }
}
