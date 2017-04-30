
import UIKit

public extension NSAttributedString {
    class func indentString(text: String, val: CGFloat) -> NSAttributedString {
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.alignment = .justified
        style.firstLineHeadIndent = val
        style.headIndent = val
        style.tailIndent = -val
        return NSAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: style])
    }
}
