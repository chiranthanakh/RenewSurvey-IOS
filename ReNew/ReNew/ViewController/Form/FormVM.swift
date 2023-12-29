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
    var selectedPanchayat: ModelPanchayat?
    var selectedVillage: ModelVillage?
    
    var isFromDraft = false
    var modelAssignedSurvey : ModelAssignedSurvey?
    var isFromAssignList = false
    var modelDraftFormDetails: ModelAsyncForm?
    
    
    var selectedTblProjectsId = kAppDelegate.selectedProjectID
    var selectedFormsId = kAppDelegate.selectedForm?.tblFormsId ?? 0
    var selectedLanguageId = kAppDelegate.selectedLanguageID 
    var selectedProjectPhaseId = kAppDelegate.selectedForm?.tblProjectPhaseId ?? 0
    var selectedphase = kAppDelegate.selectedForm?.phase ?? 0
    var selectedversion = kAppDelegate.selectedForm?.version ?? 0
    
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
            self.selectedTblProjectsId = self.modelDraftFormDetails?.tblProjectsId ?? 0
            self.selectedFormsId = self.modelDraftFormDetails?.tblFormsId ?? 0
            self.selectedLanguageId = self.modelDraftFormDetails?.mstLanguageId ?? 0
            self.selectedProjectPhaseId = self.modelDraftFormDetails?.tblProjectPhaseId ?? 0
            self.selectedphase = self.modelDraftFormDetails?.phase ?? 0
            self.selectedversion = self.modelDraftFormDetails?.version ?? 0
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
        if self.selectedFormsId != 1 {
            self.assignSurveyStaticQuestionDataBind()
        }
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
    
    func getStaticQuestionOption(question: ModelStaticQuestion) -> [ModelListSelection] {
        var returnValues = [String]()
        var arrList = [ModelListSelection]()
        
        if question.option != "" {
//            returnValues = question.option.components(separatedBy: "/")
            let arrTemp = question.option.components(separatedBy: "/")
            arrList = arrTemp.compactMap({ModelListSelection.init(id: "", name: $0)})
        }
        else if question.id == 2 {
            let arrState = DataManager.getStateList()
            returnValues = arrState.compactMap({$0.stateName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstStateId, name: $0.stateName)})
        }
        else if question.id == 3 && self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer != ""{
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            let arrState = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "")
            returnValues = arrState.compactMap({$0.districtName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstDistrictId, name: $0.districtName)})
        }
        else if question.id == 4 {
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer}).first
            
            let arrState = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "")
            returnValues = arrState.compactMap({$0.tehsilName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstTehsilId, name: $0.tehsilName)})
        }
        else if question.id == 5 {
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer}).first
            self.selectedTehsil = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "").filter({$0.tehsilName == self.arrStaticQuestion.filter({$0.id == 4}).first?.strAnswer}).first
            
            let arrState = DataManager.getPanchayatList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "")
            returnValues = arrState.compactMap({$0.panchayatName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstPanchayatId, name: $0.panchayatName)})
        }
        else if question.id == 6 { //Village
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer}).first
            self.selectedTehsil = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "").filter({$0.tehsilName == self.arrStaticQuestion.filter({$0.id == 4}).first?.strAnswer}).first
            self.selectedPanchayat = DataManager.getPanchayatList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "").filter({$0.panchayatName == self.arrStaticQuestion.filter({$0.id == 5}).first?.strAnswer}).first
            
            let arrState = DataManager.getVillageList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "", panchayatId: self.selectedPanchayat?.mstPanchayatId ?? "")
            returnValues = arrState.compactMap({$0.villageName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstVillagesId, name: $0.villageName)})
        }
//        return returnValues
        return arrList
    }
    
    func validationStaticQuestions() -> String? {
        for question in arrStaticQuestion {
            if question.strAnswer == "" {
                return "Please enter \(question.question) answer properly"
            }
            else if question.id == 19 {
                if question.strAnswer.count != 10 {
                    return "Mobile number must be 10 digit"
                }
            }
            else if question.id == 20 {
                if question.strAnswer.count != 12 {
                    return "Aadhhar card number must be 12 digit"
                }
            }
        }
        return nil
    }
    
    func validationQuestionsGroup(index: Int) -> String? {
        for question in arrFormGroup[index].questions {
            if question.ismandatory == "YES" {
                if question.questionType == "CAPTURE" {
                    if question.strImageBase64 == "" {
                        return "Please selecct \(question.title)"
                    }
                }
                else if question.strAnswer == "" {
                    return "Please enter \(question.title) answer properly"
                }
                else if question.minLength > 0 && question.strAnswer.count < question.minLength {
                    return "\(question.title) must be have minimum \(question.minLength) characters"
                }
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
                if question.ismandatory == "YES" {
                    if question.questionType == "CAPTURE" {
                        if question.strImageBase64 == "" {
                            return "Please selecct \(question.title)"
                        }
                    }
                    else if question.strAnswer == "" {
                        return "Please enter \(question.title) answer properly"
                    }
                    else if question.minLength > 0 && question.strAnswer.count < question.minLength {
                        return "\(question.title) must be have minimum \(question.minLength) characters"
                    }
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
    
    func saveDraft(isShowMsg: Bool = false) {
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
            let appUniqueCode = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(self.selectedTblProjectsId)_\(self.selectedFormsId)_\(self.selectedProjectPhaseId)_\(Date().localDate().getFormattedString(format: "dd:MM:yyyy:hh:mm:ss"))"
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: .fragmentsAllowed) {
                let query = "insert into tbl_FilledForms (tbl_users_id, tbl_projects_id, mst_language_id, tbl_forms_id, app_unique_code ,jsonValues, status, phase, version, parent_survey_id) values ('\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")','\(self.selectedTblProjectsId)','\(self.selectedLanguageId)','\(self.selectedFormsId)','\(appUniqueCode)','\(String(data: data, encoding: .utf8) ?? "")', '\(2)', '\(self.selectedphase)', '\(self.selectedversion)', '\(self.modelAssignedSurvey?.parentSurveyId ?? "")')"
                if DataManager.DML(query: query) == true, isShowMsg {
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
        let appUniqueCode = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(self.selectedTblProjectsId)_\(self.selectedFormsId)_\(self.selectedProjectPhaseId)_\(Date().localDate().getFormattedString(format: "dd:MM:yyyy:hh:mm:ss"))"
        
        var commanQueAnswers = ["banficary_name": self.arrStaticQuestion.filter({$0.id == 1}).first?.strAnswer ?? ""] as [String:Any]
        commanQueAnswers["mst_state_id"] = self.arrStaticQuestion.filter({$0.id == 2}).first?.answerId ?? 0
        commanQueAnswers["mst_district_id"] = self.arrStaticQuestion.filter({$0.id == 3}).first?.answerId ?? 0
        commanQueAnswers["mst_tehsil_id"] = self.arrStaticQuestion.filter({$0.id == 4}).first?.answerId ?? 0
        commanQueAnswers["mst_panchayat_id"] = self.arrStaticQuestion.filter({$0.id == 5}).first?.answerId ?? 0
        commanQueAnswers["mst_village_id"] = self.arrStaticQuestion.filter({$0.id == 6}).first?.answerId ?? 0
        commanQueAnswers["gender"] = self.arrStaticQuestion.filter({$0.id == 7}).first?.strAnswer ?? ""
        commanQueAnswers["mobile_number"] = self.arrStaticQuestion.filter({$0.id == 19}).first?.strAnswer ?? ""
        commanQueAnswers["family_size"] = self.arrStaticQuestion.filter({$0.id == 8}).first?.strAnswer ?? ""
        commanQueAnswers["is_lpg_using"] = self.arrStaticQuestion.filter({$0.id == 9}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cylinder_per_year"] = self.arrStaticQuestion.filter({$0.id == 10}).first?.strAnswer ?? ""
        commanQueAnswers["is_cow_dung"] = self.arrStaticQuestion.filter({$0.id == 11}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cow_dung_per_day"] = self.arrStaticQuestion.filter({$0.id == 12}).first?.strAnswer ?? ""
        commanQueAnswers["wood_use_per_day_in_kg"] = self.arrStaticQuestion.filter({$0.id == 16}).first?.strAnswer ?? ""
        commanQueAnswers["house_type"] = self.arrStaticQuestion.filter({$0.id == 13}).first?.strAnswer ?? ""
        commanQueAnswers["electricity_connection_available"] = self.arrStaticQuestion.filter({$0.id == 17}).first?.strAnswer ?? ""
        commanQueAnswers["annual_family_income"] = self.arrStaticQuestion.filter({$0.id == 14}).first?.strAnswer ?? ""
        commanQueAnswers["willing_to_contribute_clean_cooking"] = self.arrStaticQuestion.filter({$0.id == 15}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cattles_own"] = self.arrStaticQuestion.filter({$0.id == 18}).first?.strAnswer ?? ""
        commanQueAnswers["aadhar_card"] = self.arrStaticQuestion.filter({$0.id == 20}).first?.strAnswer ?? ""
        
        var commanDic = ["tbl_projects_id": self.selectedTblProjectsId,
                         "tbl_users_id": ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "",
                         "tbl_forms_id": self.selectedFormsId,
                         "mst_language_id": self.selectedLanguageId,
                         "app_unique_code": appUniqueCode,
                         "tbl_project_phase_id": self.selectedProjectPhaseId,
                         "version": self.selectedversion,
                         "phase": self.selectedphase] as [String : Any]
        
        if self.selectedFormsId != 1 {
            commanDic["parent_survey_id"] = self.modelAssignedSurvey?.parentSurveyId ?? ""
            commanDic["tbl_project_survey_common_data_id"] = self.modelAssignedSurvey?.tblProjectSurveyCommonDataId ?? ""
        }
        else {
            commanDic["parent_survey_id"] = ""
            commanDic["common_question_answer"] = commanQueAnswers
        }
        
        var arrAnswers = [[String:Any]]()
        for questionGrp in arrFormGroup {
            questionGrp.questions.forEach { question in
                arrAnswers.append(question.toDictionary())
            }
        }
        commanDic["question_answer"] = arrAnswers
        
        if let data = try? JSONSerialization.data(withJSONObject: commanDic, options: .fragmentsAllowed) {
            if self.selectedFormsId != 1 {
                self.deleteOldForm()
            }
            let query = "insert into tbl_FilledForms (tbl_users_id, tbl_projects_id, mst_language_id, tbl_forms_id, app_unique_code, phase, version, parent_survey_id ,jsonValues) values ('\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")','\(kAppDelegate.selectedProjectID)','\(self.selectedLanguageId)','\(self.selectedFormsId)','\(appUniqueCode)', '\(self.selectedphase)', '\(self.selectedversion)', '\(self.modelAssignedSurvey?.parentSurveyId ?? "")' ,'\(String(data: data, encoding: .utf8) ?? "")')"
            if DataManager.DML(query: query) == true {
                print("Inserted")
                /*if self.isFromDraft {
                    DataManager.deleteDraftData()
                }*/
                self.deleteDraft()
                self.viewController?.showAlert(with: "Form saved successfully.", firstHandler:  { _ in
                    self.viewController?.navigationController?.popViewController(animated: true)
                })
            }
            else {
                print("Error \(query)")
            }
        }
    }
    
    func deleteDraft() {
        let query = "DELETE FROM tbl_FilledForms WHERE status = '2' and tbl_projects_id = '\(self.selectedTblProjectsId)' and mst_language_id = '\(self.selectedLanguageId)' and tbl_forms_id = '\(self.selectedFormsId)' and phase = '\(self.selectedphase)' and version = '\(self.selectedversion)'"
        if DataManager.DML(query: query) == true {
            print("Inserted")
        }
    }
    
    func deleteOldForm() {
        let query = "DELETE FROM tbl_FilledForms WHERE parent_survey_id = '\(self.modelAssignedSurvey?.parentSurveyId ?? "")'"
        if DataManager.DML(query: query) == true {
            print("Inserted")
        }
    }
    
    func assignSurveyStaticQuestionDataBind() {
        if let obj = self.modelAssignedSurvey {
            self.arrStaticQuestion.forEach { staticQuestion in
                if staticQuestion.id == 1 {
                    staticQuestion.strAnswer = obj.banficaryName
                }
                else if staticQuestion.id == 2 {
                    staticQuestion.strAnswer = DataManager.getStataName(stateId: obj.mstStateId)
                }
                else if staticQuestion.id == 3 {
                    staticQuestion.strAnswer = DataManager.getDistrictName(districtId: obj.mstDistrictId)
                }
                else if staticQuestion.id == 4 {
                    staticQuestion.strAnswer = DataManager.getTehsilName(tehsilId: obj.mstTehsilId)
                }
                else if staticQuestion.id == 5 {
                    staticQuestion.strAnswer = DataManager.getVillageName(villageId: obj.mstVillageId)
                }
                else if staticQuestion.id == 6 {
                    staticQuestion.strAnswer = obj.gender
                }
                else if staticQuestion.id == 7 {
                    staticQuestion.strAnswer = obj.familySize
                }
                else if staticQuestion.id == 8 {
                    staticQuestion.strAnswer = obj.isLpgUsing
                }
                else if staticQuestion.id == 9 {
                    staticQuestion.strAnswer = obj.noOfCylinderPerYear
                }
                else if staticQuestion.id == 10 {
                    staticQuestion.strAnswer = obj.isCowDung
                }
                else if staticQuestion.id == 11 {
                    staticQuestion.strAnswer = obj.noOfCowDungPerDay
                }
                else if staticQuestion.id == 12 {
                    staticQuestion.strAnswer = obj.houseType
                }
                else if staticQuestion.id == 13 {
                    staticQuestion.strAnswer = obj.annualFamilyIncome
                }
                else if staticQuestion.id == 14 {
                    staticQuestion.strAnswer = obj.willingToContributeCleanCooking
                }
                else if staticQuestion.id == 15 {
                    staticQuestion.strAnswer = obj.woodUsePerDayInKg
                }
                else if staticQuestion.id == 16 {
                    staticQuestion.strAnswer = obj.electricityConnectionAvailable
                }
                else if staticQuestion.id == 17 {
                    staticQuestion.strAnswer = obj.noOfCattlesOwn
                }
                else if staticQuestion.id == 18 {
                    staticQuestion.strAnswer = obj.mobileNumber
                }
            }
        }
    }
}
