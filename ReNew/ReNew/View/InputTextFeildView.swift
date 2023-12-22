//
//  InputTextFeildView.swift
//  K@ Payroll
//
//  Created by Loyal Hospitality on 23/01/23.
//

import UIKit
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class InputTextFeildView: UIView {
    
    //MARK: IBOutlets
   
    @IBOutlet var txtInput: MDCOutlinedTextField!
    
    @IBOutlet var btnSelection: UIButton!
    @IBOutlet var btnShowPassword: UIButton!
    
    var contentView:UIView?
    let nibName = "InputTextFeildView"
    var completion:(()->())?
    var completionEditingComplete:((String)->())?

    var isFromTraineeEnrollment = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        initialConfig()
        self.txtInput.delegate = self
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    //MARK: - Helper Methods
    private func initialConfig() {
        
        if self.keyboard == 7{
            self.txtInput.autocapitalizationType = .none
        }
        else{
            self.txtInput.autocapitalizationType = .sentences
        }
        self.txtInput.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    //MARK: IBInspectable
    /*0: default // Default type for the current input method.

    1: asciiCapable // Displays a keyboard which can enter ASCII characters

    2: numbersAndPunctuation // Numbers and assorted punctuation.

    3: URL // A type optimized for URL entry (shows . / .com prominently).

    4: numberPad // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.

    5: phonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).

    6: namePhonePad // A type optimized for entering a person's name or phone number.

    7: emailAddress // A type optimized for multiple email address entry (shows space @ . prominently).

    8: decimalPad // A number pad with a decimal point.

    9: twitter // A type optimized for twitter text entry (easy access to @ #)*/

    @IBInspectable var keyboard:Int{
        get{
            //self.txtInput.returnKeyType.rawValue
            return self.txtInput.keyboardType.rawValue
        }
        set(keyboardIndex){
            if keyboard == 7 {
                self.txtInput.autocapitalizationType = .none
            }
            else{
                self.txtInput.autocapitalizationType = .sentences
            }
            self.txtInput.keyboardType = UIKeyboardType.init(rawValue: keyboardIndex)!
        }
    }

    @IBInspectable var isPassword : Bool = false {
        didSet {
            self.txtInput.isSecureTextEntry = isPassword
            self.btnShowPassword.isHidden = !isPassword
        }
    }
    
    @IBInspectable var isEditable : Bool = false {
        didSet {
            self.btnSelection.isHidden = !isEditable
            if isEditable {
//                self.txtInput.isEnabled = false
            }
        }
    }
    
    @IBInspectable var placeholderText: String {
        get { return self.txtInput.placeholder ?? "" }
        set {
            self.txtInput.placeholder = newValue
            self.txtInput.label.text = newValue
        }
    }
    
    @IBInspectable var topHeaderLabelText: String = "" {
        didSet {
//            self.lblTopLabel.text = topHeaderLabelText
        }
    }
    
    @IBAction func btnEdit(_ sender: UIButton) {
        if let function = self.completion {
            function()
        }
    }
    
    @IBAction func btnShowPassword(_ sender: UIButton) {
        if sender.tag == 0 {
            self.txtInput.isSecureTextEntry = false
            sender.isSelected = true
            sender.tag = 1
        }
        else {
            self.txtInput.isSecureTextEntry = true
            sender.isSelected = false
            sender.tag = 0
        }
    }
    
}

extension InputTextFeildView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let function = self.completionEditingComplete {
            function(textField.text ?? "")
        }
    }
}
