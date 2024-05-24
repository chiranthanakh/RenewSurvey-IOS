//
//  BenificaryMemberRegisterVM.swift
//  ReNew
//
//  Created by Shiyani on 29/03/24.
//

import UIKit

class BenificaryMemberRegisterVM {

    var viewController: BenificaryMemberRegisterVC?
    
    func inputValidation() -> String? {
        if (self.viewController?.vwMobileNumber.txtInput.text?.count ?? 0) != 10 {
            return "Please enter valid mobile number."
        }
        else if (self.viewController?.vwSerialNumber.txtInput.text ?? "") == "" {
            return "Please enter valid serail number."
        }
        return nil
    }
    
    func callValidateProjectAPI() {
        var param = ["project_code": "",
                     "mobile": self.viewController?.vwMobileNumber.txtInput.text ?? "",
                     "aadhar_card": "",
                     "app_key": AppConstant.Key.appKey,
                     "user_type": "USER",
                     "device_serial_number": self.viewController?.vwSerialNumber.txtInput.text ?? ""] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kValidateProject, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    if let data = responsedic["data"] as? [String:Any], let otp = data["otp"] as? String {
                        var respParam = ["app_key": AppConstant.Key.appKey] as? [String: Any] ?? [String: Any]()
                        if let projectInfo = data["project_info"] as? [String:Any], let projectId = projectInfo["tbl_projects_id"] as? String{
                            param["tbl_projects_id"] = projectId
                            param["project_code"] = projectInfo["project_code"] as? String
                            param["title"] = projectInfo["title"] as? String
                            param["state_name"] = projectInfo["state_name"] as? String
                            param["co_ordinator_id"] = projectInfo["co_ordinator_id"] as? String
                            param["access_token"] = projectInfo["access_token"] as? String
                            param["tbl_users_id"] = projectInfo["tbl_users_id"] as? String
                            respParam.merge(projectInfo) { (current, _) in current }
                        }
                        if let userInfo = data["user_info"] as? [String:Any] {
                            respParam.merge(userInfo) { (current, _) in current }
                        }
                        /*let vc = VerificationVC()
                        vc.viewModel.validtedOTP = String(otp)
                        vc.viewModel.isFromBenificarymember = true
                        vc.viewModel.dicResedParam = respParam
                        if let userInfo = data["user_info"] as? [String:Any]{
                            vc.viewModel.modelUserInfo = ModelUserInfo.init(fromDictionary: userInfo)
                        }
                        self.viewController?.navigationController?.pushViewController(vc, animated: true)*/
                        let user = ModelUser(fromDictionary: respParam)
                        user.saveCurrentUserInDefault()
                        kAppDelegate.setSyncScreen()
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
}
