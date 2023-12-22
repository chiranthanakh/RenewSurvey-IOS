//
//  UIButton.swift
//  RecordingStudio
//
//  Created by mac on 17/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

//MARK: - UIButton Extensions
extension UIButton {
    /**
        Method is used to set Attributed Text To Button
        Return : nil
     
     */
    /*func setAttributedtextButton(firstText : String,firstTextColor : UIColor = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1),firstTextFont : UIFont = UIFont.FiraSansRegularFont(ofSize: DeviceType.IS_PAD ? 22.0 : 16.0),SecondText :String,secondTextColor : UIColor = UIColor.CustomColor.appColor,secondTextFont : UIFont = UIFont.FiraSansSemiBoldFont(ofSize: DeviceType.IS_PAD ? 22.0 : 16.0)) {
        //let FirstColor : UIColor = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
        
        let accountAttributes = [NSAttributedString.Key.foregroundColor: firstTextColor, NSAttributedString.Key.font: firstTextFont]
        let signupAttributes = [NSAttributedString.Key.foregroundColor: secondTextColor, NSAttributedString.Key.font: secondTextFont]

        let account = NSMutableAttributedString(string: firstText, attributes: accountAttributes)
        let signup = NSMutableAttributedString(string: SecondText, attributes: signupAttributes)

        let combination = NSMutableAttributedString()

        combination.append(account)
        combination.append(signup)
        
        self.setAttributedTitle(combination, for: .normal)
    }*/
    /**
        Set Button image Tint Color
     */
    func setButtonImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}

class QuantityButton: UIButton{

    var row: Int = 0
    var section: Int = 0

}


class SubmitButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
        self.dropShadow(shadowWidth: 0, shadowHeight: 0, opacity: 0.2, shadowRadius: 2)
        self.backgroundColor = UIColor(named: "LigthGreenColor")
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.setTitleColor(.white, for: .normal)
    }
    
}
