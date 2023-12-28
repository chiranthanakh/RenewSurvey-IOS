//
//  UILable.swift
//  RecordingStudio
//
//  Created by mac on 21/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

extension UILabel {
    
    func setHyperlinkAttributedTextLable(text : String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: getColorFromAsset(name: "ColorHyperLink"),
                                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)]

        let updatedText = NSMutableAttributedString(string: text, attributes: accountAttributes)
        self.isUserInteractionEnabled = true
        self.attributedText = updatedText
    }
    
    func setQuestionTitleAttributedTextLable(index: Int, question: String, isMantory: String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .bold)]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let isMantoryAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        
        
        let account = NSMutableAttributedString(string: "\(index). ", attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: question, attributes: signupAttributes as [NSAttributedString.Key : Any])
        let mantory = NSMutableAttributedString(string: " *", attributes: isMantoryAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        if isMantory == "YES" {
            combination.append(mantory)
        }
        
        self.isUserInteractionEnabled = true
        self.attributedText = combination
    }
    
    func setAnniversaryAttributedTextLable(firstText: String,SecondText: String, thirdText: String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
        let thirdAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]

        
        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes as [NSAttributedString.Key : Any])
        let third = NSMutableAttributedString(string: thirdText, attributes: thirdAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        combination.append(third)
        
        self.isUserInteractionEnabled = true
        self.attributedText = combination
    }
    
    func termsAttributedTextLable(firstString: String, secondString: String) {

        let firstAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]

        
        let account = NSMutableAttributedString(string: firstString, attributes: firstAttributes as [NSAttributedString.Key : Any])
        let signup = NSMutableAttributedString(string: secondString, attributes: secondAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.isUserInteractionEnabled = true
        self.attributedText = combination
    }
    
    /*func setInvitedAttributedTextLable(firstText : String,SecondText :String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorBlack"),NSAttributedString.Key.font: UIFont.SFUITextBold(ofSize: GetAppFontSize(size: 16.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorBlack"),NSAttributedString.Key.font: UIFont.SFUITextRegular(ofSize: GetAppFontSize(size: 16.0))]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes as [NSAttributedString.Key : Any])
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.isUserInteractionEnabled = true
        self.attributedText = combination
    }

    
    
    func setCardNumberAttributedTextLable(currentNumber: String, middleString: String, totalNumber: String) {

        let accountAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorAppTheme"),NSAttributedString.Key.font: UIFont.SFUITextBold(ofSize: GetAppFontSize(size: 30.0))]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorBlack"),NSAttributedString.Key.font: UIFont.SFUITextBold(ofSize: GetAppFontSize(size: 30.0))]
        let thirdAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorAppTheme"),NSAttributedString.Key.font: UIFont.SFUITextBold(ofSize: GetAppFontSize(size: 30.0))]

        
        let account = NSMutableAttributedString(string: currentNumber, attributes: accountAttributes as [NSAttributedString.Key : Any])
        let signup = NSMutableAttributedString(string: middleString, attributes: signupAttributes as [NSAttributedString.Key : Any])
        let third = NSMutableAttributedString(string: totalNumber, attributes: thirdAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        combination.append(third)
        
        self.isUserInteractionEnabled = true
        self.attributedText = combination
    }
    
    func termsAttributedTextLable(firstString: String, secondString: String) {

        let firstAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorBlack"),NSAttributedString.Key.font: UIFont.SFUITextMedium(ofSize: GetAppFontSize(size: 16.0))]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "ColorOrange"),NSAttributedString.Key.font: UIFont.SFUITextMedium(ofSize: GetAppFontSize(size: 16.0))]

        
        let account = NSMutableAttributedString(string: firstString, attributes: firstAttributes as [NSAttributedString.Key : Any])
        let signup = NSMutableAttributedString(string: secondString, attributes: secondAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.isUserInteractionEnabled = true
        self.attributedText = combination
    }*/
    }
extension UILabel {
    //MARK: StartBlink
    func startBlink() {
        UIView.animate(withDuration: 0.8,//Time duration
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    //MARK: StopBlink
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
    
    func showAsHyperLink() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
                                  NSAttributedString.Key.foregroundColor: UIColor.blue] as [NSAttributedString.Key : Any]
        let underlineAttributedString = NSAttributedString(string: (self.text ?? ""), attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
    
    func removeHyperLink() {
        let underlineAttribute = [NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key : Any]
        let underlineAttributedString = NSAttributedString(string: (self.text ?? ""), attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
}
