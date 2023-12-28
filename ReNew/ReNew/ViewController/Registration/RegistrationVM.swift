//
//  RegistrationVM.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class RegistrationVM: NSObject {

    var viewController: RegistrationVC?
    var selectedState: ModelState?
    var selectedDistrict: ModelDistrict?
    var selectedTehsil: ModelTehsil?
    var selectedPanchayat: ModelPanchayat?
    var selectedVillage: ModelVillage?
    var strGender = "MALE"
    var dicVericifationParam = [String:Any]()
    
    func getStateList(responseData: @escaping  (_ arrState: [ModelState]?) -> Void){
        
        let param = ["app_key": AppConstant.Key.appKey]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kGetStates, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "0" {
                    if let data = responsedic["data"] as? [[String:Any]]{
                        responseData(data.compactMap(ModelState.init))
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    func getDistrictsList(stateid: String, responseData: @escaping  (_ arrDistricts: [ModelDistrict]?) -> Void){
        
        let param = ["app_key": AppConstant.Key.appKey,
                     "mst_state_id": stateid] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kGetDistricts, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "0" {
                    if let data = responsedic["data"] as? [[String:Any]]{
                        responseData(data.compactMap(ModelDistrict.init))
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    func getTehsilsList(districtsid: String, responseData: @escaping  (_ arrTehsil: [ModelTehsil]?) -> Void){
        
        let param = ["app_key": AppConstant.Key.appKey,
                     "mst_district_id": districtsid] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kGetTehsils, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "0" {
                    if let data = responsedic["data"] as? [[String:Any]]{
                        responseData(data.compactMap(ModelTehsil.init))
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    func getPanchayatsList(tehsilsid: String, responseData: @escaping  (_ arrTehsil: [ModelPanchayat]?) -> Void){
        
        let param = ["app_key": AppConstant.Key.appKey,
                     "mst_tehsil_id": tehsilsid] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kGetPanchayats, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "0" {
                    if let data = responsedic["data"] as? [[String:Any]]{
                        responseData(data.compactMap(ModelPanchayat.init))
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    func getVillagesList(panchayatid: String, responseData: @escaping  (_ arrTehsil: [ModelVillage]?) -> Void){
        
        let param = ["app_key": AppConstant.Key.appKey,
                     "mst_panchayat_id": panchayatid] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kGetVillages, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "0" {
                    if let data = responsedic["data"] as? [[String:Any]]{
                        responseData(data.compactMap(ModelVillage.init))
                    }
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    func validation() -> String? {
        if self.viewController?.vwFullName.txtInput.text == "" {
            return "Please enter fullname."
        }
        else if self.viewController?.vwUserName.txtInput.text == "" {
            return "Please enter username."
        }
        else if self.viewController?.vwUserName.txtInput.text?.count ?? 0 > 15 {
            return "Username msut be less then 15 characters"
        }
        else if self.viewController?.vwEmail.txtInput.text == "" {
            return "Please enter email."
        }
        else if (self.viewController?.vwEmail.txtInput.text)?.isValidEmail() == false{
            return "Please enter valid email."
        }
        else if self.viewController?.vwPassword.txtInput.text == "" {
            return "Please enter password."
        }
        else if self.viewController?.vwConfirmPassword.txtInput.text == "" {
            return "Please enter confirm password."
        }
        else if self.viewController?.vwConfirmPassword.txtInput.text != self.viewController?.vwPassword.txtInput.text {
            return "Password & confirm password must be match."
        }
        else if self.viewController?.vwAddress.txtInput.text == "" {
            return "Please enter address."
        }
        else if self.viewController?.vwState.txtInput.text == "" {
            return "Please select state."
        }
        else if self.viewController?.vwDistrict.txtInput.text == "" {
            return "Please select district."
        }
        else if self.viewController?.vwTehsil.txtInput.text == "" {
            return "Please select tehsil."
        }
        else if self.viewController?.vwPanchayat.txtInput.text == "" {
            return "Please select panchayat."
        }
        else if self.viewController?.vwVillage.txtInput.text == "" {
            return "Please select village."
        }
        else if self.viewController?.vwPinCode.txtInput.text == "" {
            return "Please enter pincode."
        }
        else if self.viewController?.vwPinCode.txtInput.text?.count ?? 0 != 6 {
            return "Pincode has must be 6 characters."
        }
        else if self.viewController?.vwDOB.txtInput.text == "" {
            return "Please select date of birth."
        }
        else if self.viewController?.imgUserProfile.image == UIImage(systemName: "person.crop.circle") {
            return "Please select profile photo"
        }
        else if self.viewController?.btnTermsCheckBox.tag == 0 {
            return "Please accept terms & conditions."
        }
        return nil
    }
    
    func regisetrApiCall(){
        
        let param = ["app_key": AppConstant.Key.appKey,
                     "tbl_projects_id": self.dicVericifationParam["tbl_projects_id"] ?? "",
                     "project_code": self.dicVericifationParam["project_code"] ?? "",
                     "mobile": self.dicVericifationParam["mobile"] ?? "",
                     "password": self.viewController?.vwPassword.txtInput.text ?? "",
                     "aadhar_card": self.dicVericifationParam["aadhar_card"] ?? "",
                     "full_name": self.viewController?.vwFullName.txtInput.text ?? "",
                     "username": self.viewController?.vwUserName.txtInput.text ?? "",
                     "address": self.viewController?.vwAddress.txtInput.text ?? "",
                     "mst_state_id": self.selectedState?.mstStateId ?? "",
                     "mst_village_id": self.selectedVillage?.mstVillagesId ?? "",
                     "mst_district_id": self.selectedDistrict?.mstDistrictId ?? "",
                     "mst_tehsil_id": self.selectedTehsil?.mstTehsilId ?? "",
                     "mst_panchayat_id": self.selectedPanchayat?.mstPanchayatId ?? "",
                     "pincode": self.viewController?.vwPinCode.txtInput.text ?? "",
                     "email": self.viewController?.vwEmail.txtInput.text ?? "",
                     "device_type": "IOS",
                     "device_id": UIDevice.current.identifierForVendor?.uuidString ?? "",
                     "fcm_token": "Firebase Not implment",
                     "gender": self.strGender,
                     "date_of_birth": self.viewController?.vwDOB.txtInput.text ?? "",
                     "co_ordinator_id": "1",
                     "user_type": self.dicVericifationParam["user_type"] ?? "",
                     "profile_photo": self.viewController?.imgUserProfile.image ?? UIImage()] as [String : Any]
        
        /*APIManager.sharedInstance.makeRequest(with: AppConstant.API.kRegister, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "0" {
                    print(responsedic)
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }*/
        
        APIManager.sharedInstance.requestWithPostMultipartParam(endpointurl: AppConstant.API.kRegister, parameters: param as NSDictionary, isShowLoader: true) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "0" {
                    print(responsedic)
                }
                else {
                    self.viewController?.navigationController?.pushViewController(PendingApprovalVC(), animated: true)
                }
            }
        }
    }
}
