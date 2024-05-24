//
//  OTPVerifyTCell.swift
//  ReNew
//
//  Created by Shiyani on 28/03/24.
//

import UIKit

class OTPVerifyTCell: UITableViewCell {
    
    //    @IBOutlet var btnCamera: UIButton!
    //    @IBOutlet var imgPreview: UIImageView!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var txtAnswer: UITextField!
    @IBOutlet var lblSendCode: UILabel!
    @IBOutlet var btnVerifyOTP: SubmitButton!
    @IBOutlet var btnSendOTP: SubmitButton!
    @IBOutlet var vwButtons: UIView!
    
    var completionSelection:(()->())?
    var completionEditingComplete:((String)->())?
    var completionSendCodeTap:(()->())?
    var completionVerifyTap:(()->())?
    var maxChacaterLimit = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.txtAnswer.delegate = self
        //        self.vwText.txtInput.autocapitalizationType = .sentences
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func btnSendCode(_ sender: UIButton) {
        if let function = self.completionSendCodeTap{
            function()
        }
    }
    
    @IBAction func btnVerify(_ sender: UIButton) {
        if let function = self.completionVerifyTap{
            function()
        }
    }
}

extension OTPVerifyTCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let function = self.completionEditingComplete {
            function(textField.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.maxChacaterLimit == 0 {
            return true
        }
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= self.maxChacaterLimit
    }
}

