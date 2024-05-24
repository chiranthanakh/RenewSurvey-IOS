//
//  VerificationVM.swift
//  ReNew
//
//  Created by Shiyani on 12/12/23.
//

import UIKit

class VerificationVM: NSObject {

    var viewController : VerificationVC?
    var validtedOTP = String()
    var inputOTP = String()
    var dicResedParam = [String:Any]()
    var isFromForgotPassword = false
    var isFromBenificarymember = false
    var modelUserInfo: ModelUserInfo?
    
    func resendOTP() {
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kValidateProject, method: .post, parameter: self.dicResedParam) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    if let data = responsedic["data"] as? [String:Any], let otp = data["otp"] as? String {
                        self.validtedOTP = otp
                        self.viewController?.runTimer()
                        if let userInfo = data["user_info"] as? [String:Any]{
                            self.modelUserInfo = ModelUserInfo.init(fromDictionary: userInfo)
                        }
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    func resendVerifyOTP() {
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kVerifyUser, method: .post, parameter: self.dicResedParam) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    if let data = responsedic["data"] as? [String:Any], let otp = data["otp"] as? String {
                        self.validtedOTP = otp
                        self.viewController?.runTimer()
                        if let userInfo = data["user_info"] as? [String:Any]{
                            self.modelUserInfo = ModelUserInfo.init(fromDictionary: userInfo)
                        }
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
}
