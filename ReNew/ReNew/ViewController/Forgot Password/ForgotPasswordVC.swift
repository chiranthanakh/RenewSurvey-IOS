//
//  ForgotPasswordVC.swift
//  ReNew
//
//  Created by Shiyani on 12/12/23.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet var vwMobile: InputTextFeildView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
}

//MARK: - Init Config
extension ForgotPasswordVC {
    
    private func initConfig() {
        
    }
    
    func callVerifyUserAPI() {
        var param = ["mobile": self.vwMobile.txtInput.text ?? "",
                     "app_key": AppConstant.Key.appKey] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kVerifyUser, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    if let data = responsedic["data"] as? [String:Any], let otp = data["otp"] as? String {
                        param["tbl_users_id"] = data["tbl_users_id"] as? String ?? ""
                        param["access_token"] = data["access_token"] as? String ?? ""
                        param["user_type"] = data["user_type"] as? String ?? ""
                        let vc = VerificationVC()
                        vc.viewModel.validtedOTP = String(otp)
                        vc.viewModel.dicResedParam = param
                        vc.viewModel.isFromForgotPassword = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    self.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
}

//MARK: - UiButton Action
extension ForgotPasswordVC {
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        if (self.vwMobile.txtInput.text?.count ?? 0) < 10 {
            self.showAlert(with: "Please entr valid mobile number.")
        }
        else {
            self.callVerifyUserAPI()
        }
    }
}
