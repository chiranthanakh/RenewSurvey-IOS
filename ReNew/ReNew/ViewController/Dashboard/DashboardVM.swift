//
//  DashboardVM.swift
//  ReNew
//
//  Created by Shiyani on 20/12/23.
//

import UIKit

class DashboardVM {

    var viewController: DashboardVC?
    
    
    func surveyCountDatabind() {
        let arrFroms = DataManager.getAllFromList()
        self.viewController?.lblTotalSurvey.text = "\(arrFroms.count)"
        self.viewController?.lblDraftSurvey.text = "\(arrFroms.filter({$0.status == 2}).count)"
        self.viewController?.lblSyncSurvey.text = "\(arrFroms.filter({$0.status == 1}).count)"
        self.viewController?.lblPendingToSync.text = "\(arrFroms.filter({$0.status == 0}).count)"
    }
    func getAsyncFormList() {
        let arrList = DataManager.getAsyncFromList()
        print(arrList)
        
        if let form = arrList.first {
            self.uploadMediatoServer(asyncForm: form) {
                self.updatedDbToFormUpload(asyncForm: form)
            }
        }
        else {
            self.viewController?.showAlert(with: "Form async completed.")
        }
    }
    
    
    func uploadMediatoServer(asyncForm: ModelAsyncForm, completionHandler: @escaping () -> Void) {
        var arrFileDic = [[String:Any]]()
        var arrFiles = [Any]()
        let formJson = asyncForm.jsonValues.toFragmentsAllowedJson()
        formJson.forEach { questionJson in
            if let questionAnswer = questionJson["question_answer"] as? [[String:Any]] {
                questionAnswer.forEach { question in
                    if let questionType = question["question_type"] as? String, questionType == "CAPTURE",let answer = question["strImageBase64"] as? String, let img = answer.base64ToImage() {
                        arrFiles.append(img)
                        arrFileDic.append(["tbl_users_id": asyncForm.tblUsersId,
                                           "tbl_forms_id": asyncForm.tblFormsId,
                                           "tbl_projects_id": asyncForm.tblProjectsId,
                                           "version": question["version"] as? Int ?? 0,
                                           "phase": "1",
                                           "app_unique_code": asyncForm.appUniqueCode,
                                           "tbl_form_questions_id": question["tbl_form_questions_id"] as? String ?? "",
                                           "file_name": question["answer"] as? String ?? ""])
                    }
                }
            }
        }
        if arrFiles.count == 0 {
            self.uploadFormToServer(asyncForm: asyncForm) {
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
                        self.uploadFormToServer(asyncForm: asyncForm) {
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
    
    func uploadFormToServer(asyncForm: ModelAsyncForm, completionHandler: @escaping () -> Void) {
        var arrFileDic = [[String:Any]]()
        var arrFiles = [Any]()
        var formJson = asyncForm.jsonValues.toFragmentsAllowedJson()
        
        for item in 0..<formJson.count {
            for item2 in 0..<(formJson[item]["question_answer"] as! [[String:Any]]).count {
                let x = (formJson[item]["question_answer"] as! NSArray).mutableCopy() as? NSMutableArray
                let y = (x?.object(at: item2) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary
                y?["strImageBase64"] = ""
                x?.replaceObject(at: item2, with: y)
                formJson[item]["question_answer"] = x
            }
        }
        
        print(formJson)
                
        APIManager.sharedInstance.requestAsyncDataUploadToServer(endpointurl: AppConstant.API.kSyncSurvey, parameters: formJson, isShowLoader: true) { error, dict in
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
    
    func updatedDbToFormUpload(asyncForm: ModelAsyncForm) {
        
        let query = "UPDATE tbl_FilledForms SET status = '1' WHERE id = '\(asyncForm.id)'"
        if DataManager.DML(query: query) == true {
            print("Inserted")
            self.getAsyncFormList()
        }
        else {
            print("Error \(query)")
        }
    }
}
