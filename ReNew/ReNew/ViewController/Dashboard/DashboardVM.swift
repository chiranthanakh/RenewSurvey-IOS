//
//  DashboardVM.swift
//  ReNew
//
//  Created by Shiyani on 20/12/23.
//

import UIKit

class DashboardVM {

    var viewController: DashboardVC?
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "MenuTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
    }
 
    func surveyCountDatabind() {
        let arrFroms = DataManager.getAllFromList()
        self.viewController?.lblTotalSurvey.text = "\(arrFroms.count)"
        self.viewController?.lblDraftSurvey.text = "\(arrFroms.filter({$0.status == 2}).count)"
        self.viewController?.lblSyncSurvey.text = "\(arrFroms.filter({$0.status == 1}).count)"
        self.viewController?.lblPendingToSync.text = "\(arrFroms.filter({$0.status == 0}).count)"
        
        self.viewController?.lblUserName.text = ModelUser.getCurrentUserFromDefault()?.fullName ?? ""
        self.viewController?.lblUserPhoneNo.text = ModelUser.getCurrentUserFromDefault()?.mobile ?? ""
        self.viewController?.lblUserEmail.text = ModelUser.getCurrentUserFromDefault()?.email ?? ""
        self.viewController?.imgProfile.setImage(withUrl: ModelUser.getCurrentUserFromDefault()?.profilePhoto ?? "")
    }
    
    func getAsyncFormList() {
        DataManager.syncWithServer {
            self.surveyCountDatabind()
        }
        /*let arrList = DataManager.getAsyncFromList()
        print(arrList)
        
        if arrList.count == 0 {
            self.viewController?.showAlert(with: "No any pending form to async.")
        }
        else {
            self.uploadMediatoServer(formList: arrList, asyncForm: arrList.first!) {
                self.updatedDbToFormUpload(formList: arrList)
                self.surveyCountDatabind()
            }
        }*/
    }
    
    
    func uploadMediatoServer(formList: [ModelAsyncForm], asyncForm: ModelAsyncForm, completionHandler: @escaping () -> Void) {
        var arrFileDic = [[String:Any]]()
        var arrFiles = [Any]()
        
        formList.forEach { form in
            let questionJson = form.jsonValues.toFragmentsAllowedSingleJson()
            if let questionAnswer = questionJson["question_answer"] as? [[String:Any]] {
                questionAnswer.forEach { question in
                    if let questionType = question["question_type"] as? String {
                        if questionType == "CAPTURE",let answer = question["strImageBase64"] as? String, let img = answer.base64ToImage() {
                            arrFiles.append(img)
                            arrFileDic.append(["tbl_users_id": asyncForm.tblUsersId,
                                               "tbl_forms_id": asyncForm.tblFormsId,
                                               "tbl_projects_id": asyncForm.tblProjectsId,
                                               "version": question["version"] as? Int ?? 0,
                                               "phase": asyncForm.phase,
                                               "app_unique_code": asyncForm.appUniqueCode,
                                               "tbl_form_questions_id": question["tbl_form_questions_id"] as? Int ?? 0,
                                               "file_name": question["answer"] as? String ?? ""])
                        }
                        else if questionType == "FILE", let answer = question["answer"] as? String {
                            if let url =  getFileFromDocuments(fileName: answer){
                                arrFiles.append(url)
                            }
                            
                            let fileName = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedFormID)_\(URL(fileURLWithPath: answer).lastPathComponent)"
                            arrFileDic.append(["tbl_users_id": asyncForm.tblUsersId,
                                               "tbl_forms_id": asyncForm.tblFormsId,
                                               "tbl_projects_id": asyncForm.tblProjectsId,
                                               "version": question["version"] as? Int ?? 0,
                                               "phase": asyncForm.phase,
                                               "app_unique_code": asyncForm.appUniqueCode,
                                               "tbl_form_questions_id": question["tbl_form_questions_id"] as? Int ?? 0,
                                               "file_name": fileName])
                        }
                    }
                }
            }
        }
        
        if arrFiles.count == 0 {
            self.uploadFormToServer(formList: formList, asyncForm: asyncForm) {
                completionHandler()
            }
        }
        else {
            let param = ["post_data": arrFileDic]
            APIManager.sharedInstance.requestUploadMedia(endpointurl: AppConstant.API.kSyncMedia, parameters: param as NSDictionary, arrFiles: arrFiles, isShowLoader: true) { error, dict in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let responsedic = dict {
                    if (responsedic["success"] as? String ?? "") == "1" {
                        self.uploadFormToServer(formList: formList, asyncForm: asyncForm) {
                            completionHandler()
                        }
                    }
                    else {
                        self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                    }
                }
            }
        }
    }
    
    func uploadFormToServer(formList: [ModelAsyncForm], asyncForm: ModelAsyncForm, completionHandler: @escaping () -> Void) {
        
        var dic = [[String:Any]]()
        
        formList.forEach { form in
            var formJson = form.jsonValues.toFragmentsAllowedSingleJson()
            for item2 in 0..<(formJson["question_answer"] as! [[String:Any]]).count {
                let x = (formJson["question_answer"] as! NSArray).mutableCopy() as? NSMutableArray
                let y = (x?.object(at: item2) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary
                y?["strImageBase64"] = ""
                y?["question_type"] = ""
                y?["title"] = ""
                y?["allowed_file_type"] = ""
                y?["question_Option"] = ""
                y?["mst_question_group_id"] = ""
                y?["version"] = ""
                y?["tbl_project_phase_id"] = ""
                y?["version"] = ""
                y?["minLength"] = ""
                y?["maxLength"] = ""
                y?["is_mandatory"] = ""
                x?.replaceObject(at: item2, with: y)
                formJson["question_answer"] = x
            }
            dic.append(formJson)
        }
        
        
        print(dic)
                
        APIManager.sharedInstance.requestAsyncDataUploadToServer(endpointurl: AppConstant.API.kSyncSurvey, parameters: dic, isShowLoader: true) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    print(responsedic)
                    completionHandler()
                }
                else {
                    self.viewController?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    func updatedDbToFormUpload(formList: [ModelAsyncForm]) {
        formList.forEach { asyncForm in
            let query = "UPDATE tbl_FilledForms SET status = '1' WHERE id = '\(asyncForm.id)'"
            if DataManager.DML(query: query) == true {
                print("Inserted")
            }
            else {
                print("Error \(query)")
            }
        }
        self.viewController?.showAlert(with: "Form async successfully")
        //self.getAsyncFormList()
    }
}
