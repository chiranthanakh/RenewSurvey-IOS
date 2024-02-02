//
//  TextBoxQuestionTCell.swift
//  ReNew
//
//  Created by Shiyani on 15/12/23.
//

import UIKit

class TextBoxQuestionTCell: UITableViewCell {

//    @IBOutlet var btnCamera: UIButton!
//    @IBOutlet var imgPreview: UIImageView!
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var txtAnswer: UITextField!
    @IBOutlet var btnSelection: UIButton!
    @IBOutlet var imgCamera: UIImageView!
    @IBOutlet var vwTopBlur: UIView!
    
    var completionSelection:(()->())?
    var completionEditingComplete:((String)->())?
    var maxChacaterLimit = 0
    
    var isSelection: Bool = false {
        didSet {
            self.btnSelection.isHidden = !isSelection
            self.txtAnswer.isEnabled = !isSelection
        }
    }
    
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
    
    @IBAction func btnEdit(_ sender: UIButton) {
        if let function = self.completionSelection {
            function()
        }
    }
    
}

extension TextBoxQuestionTCell: UITextFieldDelegate {
    
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
