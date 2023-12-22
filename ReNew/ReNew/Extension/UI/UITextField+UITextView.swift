//
//  UITextField+UITextView.swift
//  RecordingStudio
//
//  Created by KETAN SODVADIYA on 23/01/19.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit


// MARK: - UITextField's Extension

extension UITextField {
    
    /**
     This property is used to check textfiled/textview is empry or not.
     */
    public var isEmpty: Bool {
        get {
            return (self.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    /**
     This method is used to validate name field.
     - Returns: Return boolen value to indicate name is valid or not
     */
    func isValidName() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        return (self.text ?? "").rangeOfCharacter(from: set.inverted) == nil
    }
    
    /**
     This method is used to validate email field.
     - Returns: Return boolen value to indicate email is valid or not
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{1,}(\\.[A-Za-z]{1,}){0,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    /**
     This method is used to validate phone number field.
     - Returns: Return boolen value to indicate phone number is valid or not
     */
    func isValidPhoneno() -> Bool {
        let count = (self.text ?? "").count
        return count >= 7 && count <= 15
    }
    
    /**
     This method is used to validate password field.
     - Returns: Return boolen value to indicate password is valid or not
     */
    func isValidPassword() -> Bool {
        let text = self.text ?? ""
        guard let _ = text.rangeOfCharacter(from: .letters), let _ = text.rangeOfCharacter(from: .decimalDigits), text.count >= 6 else {
            return false
        }
        return true
    }
    
    /**
    This method is used to validate Card Number field.
    - Returns: Return boolen value to indicate card is valid or not
    */
    func isValidCard() -> Bool {
        let count = (self.text ?? "").count
        return count == 16
    }
    /**
     This method is used to validate Expiry Date field.
     - Returns: Return boolen value to indicate date is valid or not
     */
    func isValidExpiryDate() -> Bool {
        let regex = try! NSRegularExpression(pattern: "(0[1-9]|10|11|12)/([0-9][0-9])$")
        return regex.firstMatch(in: self.text ?? "", options: [], range: NSMakeRange(0, (self.text ?? "").count)) != nil
    }
    
    /**
    This method is used to validate Card CVV field.
    - Returns: Return boolen value to indicate card CVV is valid or not
    */
    func isValidCVV() -> Bool {
        let count = (self.text ?? "").count
        return count == 3
    }
    
    /**
    This method is used to set placeholder of field.
    - Returns: nil
    */
    func setPlaceHolderColor(text : String,color : UIColor = UIColor.white) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextView{
    
    /**
     This property is used to check textfiled/textview is empry or not.
     */
    public var isEmpty: Bool {
        get {
            return (self.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
   /* func setAttributedFeedText(str : String) {
        let nsText: NSString = str as NSString
        let words:[String] = nsText.components(separatedBy: .whitespacesAndNewlines)
        let attributedString = NSMutableAttributedString(string: nsText as String, attributes: [NSAttributedString.Key.font:UIFont.SFUITextRegular(ofSize: GetAppFontSize(size: GetAppFontSize(size: 14.0)))])
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.SFUITextRegular(ofSize: GetAppFontSize(size: GetAppFontSize(size: 14.0)))]
        
        let linkFontAttribute = [NSAttributedString.Key.font: UIFont.SFUITextRegular(ofSize: GetAppFontSize(size: GetAppFontSize(size: 14.0))),NSAttributedString.Key.foregroundColor : UIColor.blue,NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        for word in words {
            if word.hasPrefix("#") {
                let matchRange:NSRange = nsText.range(of: word as String)
                attributedString.addAttributes(boldFontAttribute, range: matchRange)
                // for append value in string
            }
            
            let w = word.lowercased()
            if w.contains("http:") || w.contains("www.") || w.contains("https:") {
                
                let matchRange:NSRange = nsText.range(of: word as String)
                attributedString.addAttributes(linkFontAttribute, range: matchRange)
            }
        }
        
        self.attributedText = attributedString
        
    }*/
}

extension UITextView {

    private class PlaceholderLabel: UILabel { }

    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            label.textColor = UIColor.gray
            addSubview(label)
            return label
        }
    }

    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)

            textStorage.delegate = self
        }
    }

}

extension UITextView: NSTextStorageDelegate {

    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }

}
