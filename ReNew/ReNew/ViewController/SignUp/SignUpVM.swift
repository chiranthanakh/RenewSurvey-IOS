//
//  SignUpVM.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class SignUpVM: NSObject {

    var viewController: SignUpVC?
    var selecteduserRole : UserRole = .User{
        didSet {
            self.userRoleUpdated()
        }
    }
    
    
    func userRoleUpdated() {
        self.viewController?.vwProjectCode.isHidden = (self.selecteduserRole == .User)
        
    }
    
    func inputValidation() -> String? {
        if self.selecteduserRole == .Member && self.viewController?.vwProjectCode.txtInput.text == "" {
            return "Please entr project code"
        }
        else if (self.viewController?.vwMobileNumber.txtInput.text?.count ?? 0) != 10 {
            return "Please enter valid mobile number."
        }
        else if (self.viewController?.vwAadharNumber.txtInput.text?.count ?? 0) != 12 {
            return "Please enter valid aadhar number."
        }
        return nil
    }
    
    func callValidateProjectAPI() {
        var param = ["project_code": self.viewController?.vwProjectCode.txtInput.text ?? "",
                     "mobile": self.viewController?.vwMobileNumber.txtInput.text ?? "",
                     "aadhar_card": self.viewController?.vwAadharNumber.txtInput.text ?? "",
                     "app_key": AppConstant.Key.appKey,
                     "user_type": (self.selecteduserRole == .User ? "USER" : "MEMBER")] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kValidateProject, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    if let data = responsedic["data"] as? [String:Any], let otp = data["otp"] as? String {
                        if let projectInfo = data["project_info"] as? [String:Any], let projectId = projectInfo["tbl_projects_id"] as? String{
                            param["tbl_projects_id"] = projectId
                            param["project_code"] = projectInfo["project_code"] as? String
                            param["title"] = projectInfo["title"] as? String
                            param["state_name"] = projectInfo["state_name"] as? String
                            param["co_ordinator_id"] = projectInfo["co_ordinator_id"] as? String
                        }
                        let vc = VerificationVC()
                        vc.viewModel.validtedOTP = String(otp)
                        vc.viewModel.dicResedParam = param
                        if let userInfo = data["user_info"] as? [String:Any]{
                            vc.viewModel.modelUserInfo = ModelUserInfo.init(fromDictionary: userInfo)
                        }
                        self.viewController?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
}
