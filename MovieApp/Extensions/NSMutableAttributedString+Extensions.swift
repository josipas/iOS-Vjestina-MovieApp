import Foundation
import UIKit

extension NSMutableAttributedString {
    class func getAPartialBoldAttributedString(fromString string: String, withSubstring substring: String, forSize size: Int, color: UIColor) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: string)
        attributedText.apply(font: .systemFont(ofSize: CGFloat(size)), subString: string)
        attributedText.apply(font: .boldSystemFont(ofSize: CGFloat(size)), subString: substring)
        attributedText.apply(color: color, subString: string)
        
        return attributedText
    }

    func apply(font: UIFont, subString: String)  {
        if let range = self.string.range(of: subString) {
            self.apply(font: font, onRange: NSRange(range, in: self.string))
        }
    }

    func apply(font: UIFont, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.font: font], range: onRange)
    }

    func apply(color: UIColor, subString: String) {

        if let range = self.string.range(of: subString) {
          self.apply(color: color, onRange: NSRange(range, in:self.string))
        }
      }

      func apply(color: UIColor, onRange: NSRange) {
        self.addAttributes([NSAttributedString.Key.foregroundColor: color],
                           range: onRange)
      }
}

