//
//  FormVM.swift
//  ReNew
//
//  Created by Shiyani on 14/12/23.
//

import UIKit



class FormVM: NSObject {

    var viewController: FormVC?
    var arrFormGroup = [ModelFormGroup]()
    var arrStaticQuestion = [ModelStaticQuestion]()
    var selectedGrpIndex = -1
    var selectedState: ModelState?
    var selectedDistrict: ModelDistrict?
    var selectedTehsil: ModelTehsil?
    var selectedVillage: ModelVillage?
    
    var isFromDraft = false
    
    func registerController() {
        self.viewController?.collectionFormGroup.registerCell(withNib: "FormGroupTitleCCell")
        self.viewController?.collectionFormGroup.delegate = self.viewController
        self.viewController?.collectionFormGroup.dataSource = self.viewController
        
        self.viewController?.tblQuestion.registerCell(withNib: "TextBoxQuestionTCell")
        self.viewController?.tblQuestion.registerCell(withNib: "RatingQuestionTCell")
        self.viewController?.tblQuestion.delegate = self.viewController
        self.viewController?.tblQuestion.dataSource = self.viewController
        self.viewController?.tblQuestion.separatorStyle = .none
        
        if self.isFromDraft {
            self.viewController?.tblQuestion.reloadData()
        }
        else {
            self.getStaticQuestions()
            self.getFormGroup()
        }
    }
    
    func getFormGroup() {
        arrFormGroup = DataManager.getFormGroupList()
        self.getQuestions()
    }
    
    func getStaticQuestions() {
        self.arrStaticQuestion = DataManager.getStaticQuestionList()
        self.viewController?.collectionFormGroup.reloadData()
    }
    
    func getQuestions() {
        arrFormGroup.forEach { questionGroup in
            questionGroup.questions = DataManager.getQuestionList(grpId: questionGroup.mstQuestionGroupId)
        }
        self.getQuestionOption()
    }
    
    func getQuestionOption() {
        arrFormGroup.forEach { questiongrp in
            questiongrp.questions.forEach { question in
                question.questionOption = DataManager.getQuestionOptionList(questionId: question.tblFormQuestionsId)
            }
        }
        self.viewController?.collectionFormGroup.reloadData()
        self.viewController?.tblQuestion.reloadData()
    }
    
    func getStaticQuestionOption(question: ModelStaticQuestion) -> [String] {
        var returnValues = [String]()
        if question.option != "" {
            returnValues = question.option.components(separatedBy: "/")
        }
        else if question.id == 2 {
            let arrState = DataManager.getStateList()
            returnValues = arrState.compactMap({$0.stateName})
        }
        else if question.id == 3 && self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer != ""{
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            let arrState = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "")
            returnValues = arrState.compactMap({$0.districtName})
        }
        else if question.id == 4 {
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer}).first
            
            let arrState = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "")
            returnValues = arrState.compactMap({$0.tehsilName})
        }
        else if question.id == 5 {
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer}).first
            self.selectedTehsil = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "").filter({$0.tehsilName == self.arrStaticQuestion.filter({$0.id == 4}).first?.strAnswer}).first
            
            let arrState = DataManager.getVillageList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "")
            returnValues = arrState.compactMap({$0.villageName})
        }
        return returnValues
    }
    
    func validationStaticQuestions() -> String? {
        for question in arrStaticQuestion {
            if question.strAnswer == "" {
                return "Please enter \(question.question) answer properly"
            }
        }
        return nil
    }
    
    
    func validationAllForms() -> String? {
        if let msg = self.validationStaticQuestions() {
            return msg
        }
        for questionGrp in arrFormGroup {
            for question in questionGrp.questions {
                if question.strAnswer == "" {
                    return "Please enter \(question.title) answer properly"
                }
                else if question.minLength > 0 && question.strAnswer.count < question.minLength {
                    return "\(question.title) must be have minimum \(question.minLength) characters"
                }
            }
        }
        return nil
    }
    
    
    func checkValidationForSaveButton() {
        if let msg = self.validationAllForms() {
            print(msg)
            self.viewController?.vwHeader.btnRightOption.setTitle("Save As Draft", for: .normal)
        }
        else {
            self.viewController?.vwHeader.btnRightOption.setTitle("Save", for: .normal)
        }
    }
    func saveDraft() {
        if let msg = self.validationStaticQuestions() {
            self.viewController?.showAlert(with: msg)
            return
        }
        else {
            let draftModel = ModelFormDraft(fromDictionary: [:])
            draftModel.staticQuestions = self.arrStaticQuestion
            draftModel.grpForm = self.arrFormGroup
            let dic = draftModel.toDictionary()
            DataManager.deleteDraftData()
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: .fragmentsAllowed) {
                let query = "insert into tbl_FilledForms (tbl_users_id, tbl_projects_id, mst_language_id, tbl_forms_id, app_unique_code ,jsonValues, status) values ('\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")','\(kAppDelegate.selectedProjectID)','\(kAppDelegate.selectedLanguageID)','\(kAppDelegate.selectedFormID)','\(String(Date().timeIntervalSince1970))','\(String(data: data, encoding: .utf8) ?? "")', '\(2)')"
                if DataManager.DML(query: query) == true {
                    print("Inserted")
                    self.viewController?.showAlert(with: "Form saved as draft.", firstHandler:  { _ in
                        self.viewController?.navigationController?.popViewController(animated: true)
                    })
                }
                else {
                    print("Error \(query)")
                }
            }
        }
        
    }
    
    func saveToLocalDb() {
        if let msg = self.validationAllForms() {
            self.viewController?.showAlert(with: msg)
            return
        }
        var dicMain = [[String:Any]]()
        let appUniqueCode = String(Date().timeIntervalSince1970)
        
        var commanQueAnswers = ["banficary_name": self.arrStaticQuestion.filter({$0.id == 1}).first?.strAnswer ?? ""]
        commanQueAnswers["mst_state_id"] = self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer ?? ""
        commanQueAnswers["mst_district_id"] = self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer ?? ""
        commanQueAnswers["mst_tehsil_id"] = self.arrStaticQuestion.filter({$0.id == 4}).first?.strAnswer ?? ""
        commanQueAnswers["mst_village_id"] = self.arrStaticQuestion.filter({$0.id == 5}).first?.strAnswer ?? ""
        commanQueAnswers["gender"] = self.arrStaticQuestion.filter({$0.id == 6}).first?.strAnswer ?? ""
        commanQueAnswers["mobile_number"] = self.arrStaticQuestion.filter({$0.id == 18}).first?.strAnswer ?? ""
        commanQueAnswers["family_size"] = self.arrStaticQuestion.filter({$0.id == 7}).first?.strAnswer ?? ""
        commanQueAnswers["is_lpg_using"] = self.arrStaticQuestion.filter({$0.id == 8}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cylinder_per_year"] = self.arrStaticQuestion.filter({$0.id == 9}).first?.strAnswer ?? ""
        commanQueAnswers["is_cow_dung"] = self.arrStaticQuestion.filter({$0.id == 10}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cow_dung_per_day"] = self.arrStaticQuestion.filter({$0.id == 11}).first?.strAnswer ?? ""
        commanQueAnswers["wood_use_per_day_in_kg"] = self.arrStaticQuestion.filter({$0.id == 15}).first?.strAnswer ?? ""
        commanQueAnswers["house_type"] = self.arrStaticQuestion.filter({$0.id == 12}).first?.strAnswer ?? ""
        commanQueAnswers["electricity_connection_available"] = self.arrStaticQuestion.filter({$0.id == 16}).first?.strAnswer ?? ""
        commanQueAnswers["annual_family_income"] = self.arrStaticQuestion.filter({$0.id == 13}).first?.strAnswer ?? ""
        commanQueAnswers["willing_to_contribute_clean_cooking"] = self.arrStaticQuestion.filter({$0.id == 14}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cattles_own"] = self.arrStaticQuestion.filter({$0.id == 17}).first?.strAnswer ?? ""
        
        
        for questionGrp in arrFormGroup {
            var commanDic = ["tbl_projects_id": kAppDelegate.selectedProjectID,
                             "tbl_users_id": ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "",
                             "tbl_forms_id": kAppDelegate.selectedFormID,
                             "mst_language_id": kAppDelegate.selectedLanguageID,
                             "app_unique_code": appUniqueCode,
                             "tbl_project_phase_id": questionGrp.questions.first?.tblProjectPhaseId ?? "",
                             "version": questionGrp.questions.first?.version ?? "",
                             "parent_survey_id": "",
                             "phase": ""] as [String : Any]
            
            var arrAnswers = [[String:Any]]()
            questionGrp.questions.forEach { question in
                arrAnswers.append(question.toDictionary())
            }
            commanDic["common_question_answer"] = commanQueAnswers
            commanDic["question_answer"] = arrAnswers
            dicMain.append(commanDic)
        }
                
        if let data = try? JSONSerialization.data(withJSONObject: dicMain, options: .fragmentsAllowed) {
            let query = "insert into tbl_FilledForms (tbl_users_id, tbl_projects_id, mst_language_id, tbl_forms_id, app_unique_code ,jsonValues) values ('\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")','\(kAppDelegate.selectedProjectID)','\(kAppDelegate.selectedLanguageID)','\(kAppDelegate.selectedFormID)','\(appUniqueCode)','\(String(data: data, encoding: .utf8) ?? "")')"
            if DataManager.DML(query: query) == true {
                print("Inserted")
                if self.isFromDraft {
                    DataManager.deleteDraftData()
                }
                self.viewController?.showAlert(with: "Form saved successfully.", firstHandler:  { _ in
                    self.viewController?.navigationController?.popViewController(animated: true)
                })
            }
            else {
                print("Error \(query)")
            }
        }
    }
}
