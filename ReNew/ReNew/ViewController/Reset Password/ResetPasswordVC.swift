//
//  ResetPasswordVC.swift
//  ReNew
//
//  Created by Shiyani on 12/12/23.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet var vwoldPassword: InputTextFeildView!
    @IBOutlet var vwNewPassword: InputTextFeildView!
    @IBOutlet var vwConfirmPassword: InputTextFeildView!
    
    var dicParam = [String:Any]()
    var isFromChangePassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func btnSumit(_ sender: UIButton) {
        if self.isFromChangePassword && self.vwoldPassword.txtInput.text == "" {
            self.showAlert(with: "Please enter old password.")
        }
        else if self.vwNewPassword.txtInput.text == "" {
            self.showAlert(with: "Please enter password.")
        }
        else if self.vwConfirmPassword.txtInput.text == "" {
            self.showAlert(with: "Please enter confirm password.")
        }
        else {
            self.callResetPasswordAPI()
        }
    }
    
}

//MARK: - Init Config
extension ResetPasswordVC {
    
    func callResetPasswordAPI() {
        dicParam["new_password"] = self.vwNewPassword.txtInput.text ?? ""
        dicParam["confirm_password"] = self.vwConfirmPassword.txtInput.text ?? ""
        
        if self.isFromChangePassword {
            dicParam["old_password"] = self.vwoldPassword.txtInput.text ?? ""
            dicParam["access_token"] = ModelUser.getCurrentUserFromDefault()?.accessToken ?? ""
        }
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kResetPassword, method: .post, parameter: self.dicParam) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    self.showAlert(with: responsedic["message"] as? String ?? "", firstHandler:  { action in
                        
                    })
                }
                else {
                    self.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
}
