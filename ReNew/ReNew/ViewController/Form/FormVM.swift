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
    var selectedGrpIndex = -1 {
        didSet{
            if self.selectedGrpIndex == self.arrFormGroup.count-1 {
                self.viewController?.btnNext.setTitle("Finish", for: .normal)
            }
            else {
                self.viewController?.btnNext.setTitle("Next", for: .normal)
            }
        }
    }
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
    
    var strOTP = String()
    var isVerificationSuccess = false
    var intOTPTimer = 0
    
    var isAllowCollectData = true{
        didSet{
            self.viewController?.collectionFormGroup.reloadData()
            self.viewController?.tblQuestion.reloadData()
            if self.isAllowCollectData {
                self.viewController?.btnNext.setTitle("Next", for: .normal)
            }
            else {
                self.viewController?.btnNext.setTitle("Save", for: .normal)
            }
        }
    }
    
    func registerController() {
        self.viewController?.collectionFormGroup.registerCell(withNib: "FormGroupTitleCCell")
        self.viewController?.collectionFormGroup.delegate = self.viewController
        self.viewController?.collectionFormGroup.dataSource = self.viewController
        
        self.viewController?.tblQuestion.registerCell(withNib: "TextBoxQuestionTCell")
        self.viewController?.tblQuestion.registerCell(withNib: "RatingQuestionTCell")
        self.viewController?.tblQuestion.registerCell(withNib: "OTPVerifyTCell")
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
            if self.arrStaticQuestion.count >= 2 && self.arrStaticQuestion[1].strAnswer.lowercased() == "no" {
                self.isAllowCollectData = false
            }
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
        if self.selectedFormsId != 1 && self.selectedFormsId != 4{
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
        else if question.id == 10 {
            let arrState = DataManager.getStateList()
            returnValues = arrState.compactMap({$0.stateName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstStateId, name: $0.stateName)})
        }
        else if question.id == 11 && self.arrStaticQuestion.filter({$0.id == 10}).first?.strAnswer != ""{
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 10}).first?.strAnswer}).first
            let arrState = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "")
            returnValues = arrState.compactMap({$0.districtName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstDistrictId, name: $0.districtName)})
        }
        else if question.id == 12 {
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 10}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 11}).first?.strAnswer}).first
            
            let arrState = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "")
            returnValues = arrState.compactMap({$0.tehsilName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstTehsilId, name: $0.tehsilName)})
        }
        /*else if question.id == 13 { // Panchayat
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer}).first
            self.selectedTehsil = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "").filter({$0.tehsilName == self.arrStaticQuestion.filter({$0.id == 4}).first?.strAnswer}).first
            
            let arrState = DataManager.getPanchayatList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "")
            returnValues = arrState.compactMap({$0.panchayatName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstPanchayatId, name: $0.panchayatName)})
        }*/
        else if question.id == 13 { //Village
            self.selectedState = DataManager.getStateList().filter({$0.stateName == self.arrStaticQuestion.filter({$0.id == 10}).first?.strAnswer}).first
            self.selectedDistrict = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").filter({$0.districtName == self.arrStaticQuestion.filter({$0.id == 11}).first?.strAnswer}).first
            self.selectedTehsil = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "").filter({$0.tehsilName == self.arrStaticQuestion.filter({$0.id == 12}).first?.strAnswer}).first
            
            let arrState = DataManager.getVillageList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "")
            returnValues = arrState.compactMap({$0.villageName})
            arrList = arrState.compactMap({ModelListSelection.init(id: $0.mstVillagesId, name: $0.villageName)})
        }
//        return returnValues
        return arrList
    }
    
    func validationStaticQuestions() -> String? {
        if self.selectedFormsId == 2 {
            for question in arrStaticQuestion {
                if question.id == 32 && question.strAnswer == "" {
                    return "Please enter device serial number"
                }
                else if self.isVerificationSuccess == false && self.isFromDraft == false{
                    return "Please verify otp."
                }
            }
        }
        else {
            for question in arrStaticQuestion {
                if question.type == "CAPTURE" {
                    if question.strAnswer == "" && question.id != 25 && question.id != 26 && question.id != 27 && question.id != 19 && question.id != 7 && question.id != 8 && question.id != 9{
                        return "Please selecct \(question.questiontitle())"
                    }
                }
                else if question.strAnswer == "" && (question.id == 19 || question.id == 20) && arrStaticQuestion[17].strAnswer.lowercased() == "yes"{
                    return "Please enter \(question.questiontitle()) answer properly"
                }
                else if question.strAnswer == "" && (question.id == 7 || question.id == 8 || question.id == 9) && arrStaticQuestion[5].strAnswer.lowercased() == "yes"{
                    return "Please select Aadharcard photo"
                }
                else if question.strAnswer == "" && (question.id == 25 || question.id == 26 || question.id == 27) && arrStaticQuestion[23].strAnswer.lowercased() == "yes"{
                    return "Please enter \(question.questiontitle()) answer properly"
                }
                else if question.strAnswer == "" && question.id != 25 && question.id != 26 && question.id != 27 && question.id != 19 && question.id != 20 && question.id != 7 && question.id != 8 && question.id != 9{
                    return "Please enter \(question.questiontitle()) answer properly"
                }
                else if question.remark == "Digit 10" {
                    if question.strAnswer.count != 10 {
                        return "\(question.questiontitle()) must be 10 digit"
                    }
                }
                else if question.remark == "Digit 12" {
                    if (question.id == 7) {
                        if arrStaticQuestion[5].strAnswer.lowercased() == "yes" && question.strAnswer.count != 12 {
                            return "\(question.questiontitle()) must be 12 digit"
                        }
                    }
                    else if question.strAnswer.count != 12 {
                        return "\(question.questiontitle()) must be 12 digit"
                    }
                }
                else if question.id == 32 && question.strAnswer == "" {
                    return "Please enter device serial number"
                }
            }
            let queFullFamily = Int(self.arrStaticQuestion.filter({$0.id == 15}).first?.strAnswer ?? "") ?? 0
            let queAboveFamily = Int(self.arrStaticQuestion.filter({$0.id == 16}).first?.strAnswer ?? "") ?? 0
            let queBelowFamily = Int(self.arrStaticQuestion.filter({$0.id == 17}).first?.strAnswer ?? "") ?? 0
            if queFullFamily != (queAboveFamily+queBelowFamily){
                return "Sum of family members above 15 years and below 15 yearsmust be equals to family size"
            }
        }
        return nil
    }
    
    func validationQuestionsGroup(index: Int) -> String? {
        for question in arrFormGroup[index].questions {
            if question.ismandatory == "YES" {
                if question.questionType == "CAPTURE" {
                    if question.strAnswer == "" {
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
                        if question.strAnswer == "" {
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
//            self.viewController?.vwHeader.btnRightOption.setTitle("Save As Draft", for: .normal)
        }
        else {
//            self.viewController?.vwHeader.btnRightOption.setTitle("Save", for: .normal)
        }
    }
    
    func saveDraft(isShowMsg: Bool = false) {
        if let msg = self.validationStaticQuestions(), self.isAllowCollectData{
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
            var tempParentSurveyId = Int()
            var temptblProjectSurveyCommonDataId = String()
            
            if self.isFromDraft {
                tempParentSurveyId = self.modelDraftFormDetails?.parentSurveyId ?? Int()
                temptblProjectSurveyCommonDataId = self.modelDraftFormDetails?.tblProjectSurveyCommonDataId ?? ""
            }
            else {
                tempParentSurveyId = Int(self.modelAssignedSurvey?.parentSurveyId ?? "") ?? Int()
                temptblProjectSurveyCommonDataId = self.modelAssignedSurvey?.tblProjectSurveyCommonDataId ?? ""
            }
            
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: .fragmentsAllowed) {
                let query = "insert into tbl_FilledForms (tbl_users_id, tbl_projects_id, mst_language_id, tbl_forms_id, app_unique_code ,jsonValues, status, phase, version, parent_survey_id, tblProjectPhaseId,tblProjectSurveyCommonDataId) values ('\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")','\(self.selectedTblProjectsId)','\(self.selectedLanguageId)','\(self.selectedFormsId)','\(appUniqueCode)','\(String(data: data, encoding: .utf8) ?? "")', '\(2)', '\(self.selectedphase)', '\(self.selectedversion)', '\(tempParentSurveyId)','\(self.selectedProjectPhaseId)','\(temptblProjectSurveyCommonDataId)')"
                if DataManager.DML(query: query) == true  {
                    print("Inserted")
                    if isShowMsg {
                        self.viewController?.showAlert(with: "Form saved as draft.", firstHandler:  { _ in
                            self.viewController?.navigationController?.popViewController(animated: true)
                        })
                    }
                }
                else {
                    print("Error \(query)")
                }
            }
        }
    }
    
    func saveToLocalDb() {
        if let msg = self.validationAllForms(), self.isAllowCollectData {
            self.viewController?.showAlert(with: msg)
            return
        }
        let appUniqueCode = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(self.selectedTblProjectsId)_\(self.selectedFormsId)_\(self.selectedProjectPhaseId)_\(Date().localDate().getFormattedString(format: "dd:MM:yyyy:hh:mm:ss"))"
        
        var commanQueAnswers = ["date_and_time_of_visit": self.arrStaticQuestion.filter({$0.id == 1}).first?.strAnswer ?? ""] as [String:Any]
        
        commanQueAnswers["did_the_met_person_allowed_for_data"] = self.arrStaticQuestion.filter({$0.id == 2}).first?.strAnswer ?? ""
        commanQueAnswers["gps_location"] = self.arrStaticQuestion.filter({$0.id == 3}).first?.strAnswer ?? ""
        commanQueAnswers["banficary_name"] = self.arrStaticQuestion.filter({$0.id == 4}).first?.strAnswer ?? ""
        commanQueAnswers["mobile_number"] = self.arrStaticQuestion.filter({$0.id == 5}).first?.strAnswer ?? ""
        commanQueAnswers["do_you_have_aadhar_card"] = self.arrStaticQuestion.filter({$0.id == 6}).first?.strAnswer ?? ""
        commanQueAnswers["aadhar_card"] = self.arrStaticQuestion.filter({$0.id == 7}).first?.strAnswer ?? ""
        commanQueAnswers["font_photo_of_aadar_card"] = self.arrStaticQuestion.filter({$0.id == 8}).first?.strAnswer ?? ""
        commanQueAnswers["back_photo_of_aadhar_card"] = self.arrStaticQuestion.filter({$0.id == 9}).first?.strAnswer ?? ""
        commanQueAnswers["mst_state_id"] = self.arrStaticQuestion.filter({$0.id == 10}).first?.answerId ?? 0
        commanQueAnswers["mst_district_id"] = self.arrStaticQuestion.filter({$0.id == 11}).first?.answerId ?? 0
        commanQueAnswers["mst_tehsil_id"] = self.arrStaticQuestion.filter({$0.id == 12}).first?.answerId ?? 0
        commanQueAnswers["mst_village_id"] = self.arrStaticQuestion.filter({$0.id == 13}).first?.answerId ?? 0
        commanQueAnswers["gender"] = self.arrStaticQuestion.filter({$0.id == 14}).first?.strAnswer ?? ""
        commanQueAnswers["family_size"] = self.arrStaticQuestion.filter({$0.id == 15}).first?.strAnswer ?? ""
        commanQueAnswers["family_member_above_15_year"] = self.arrStaticQuestion.filter({$0.id == 16}).first?.strAnswer ?? ""
        commanQueAnswers["family_member_below_15_year"] = self.arrStaticQuestion.filter({$0.id == 17}).first?.strAnswer ?? ""
        commanQueAnswers["is_lpg_using"] = self.arrStaticQuestion.filter({$0.id == 18}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cylinder_per_year"] = self.arrStaticQuestion.filter({$0.id == 19}).first?.strAnswer ?? ""
        commanQueAnswers["cost_of_lpg_cyliner"] = self.arrStaticQuestion.filter({$0.id == 20}).first?.strAnswer ?? ""
        commanQueAnswers["house_type"] = self.arrStaticQuestion.filter({$0.id == 21}).first?.strAnswer ?? ""
        commanQueAnswers["annual_family_income"] = self.arrStaticQuestion.filter({$0.id == 22}).first?.strAnswer ?? ""
        commanQueAnswers["willing_to_contribute_clean_cooking"] = self.arrStaticQuestion.filter({$0.id == 23}).first?.strAnswer ?? ""
        commanQueAnswers["electricity_connection_available"] = self.arrStaticQuestion.filter({$0.id == 24}).first?.strAnswer ?? ""
        commanQueAnswers["total_electricity_bill"] = self.arrStaticQuestion.filter({$0.id == 25}).first?.strAnswer ?? ""
        commanQueAnswers["frequency_of_bill_payment"] = self.arrStaticQuestion.filter({$0.id == 26}).first?.strAnswer ?? ""
        commanQueAnswers["photo_of_bill"] = self.arrStaticQuestion.filter({$0.id == 27}).first?.strAnswer ?? ""
        commanQueAnswers["no_of_cattles_own"] = self.arrStaticQuestion.filter({$0.id == 28}).first?.strAnswer ?? ""
        commanQueAnswers["do_you_have_ration_or_aadhar"] = self.arrStaticQuestion.filter({$0.id == 29}).first?.strAnswer ?? ""
        commanQueAnswers["farmland_is_owned_by_benficary"] = self.arrStaticQuestion.filter({$0.id == 30}).first?.strAnswer ?? ""
        commanQueAnswers["if_5m_area_is_available_near_by"] = self.arrStaticQuestion.filter({$0.id == 31}).first?.strAnswer ?? ""

        if let deviceSerialNumber = self.arrStaticQuestion.filter({$0.id == 32}).first{
            commanQueAnswers["device_serial_number"] = deviceSerialNumber.strAnswer
        }
        


        /*commanQueAnswers["mst_state_id"] = self.arrStaticQuestion.filter({$0.id == 2}).first?.answerId ?? 0
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
        commanQueAnswers["aadhar_card"] = self.arrStaticQuestion.filter({$0.id == 20}).first?.strAnswer ?? ""*/
        
        var commanDic = ["tbl_projects_id": self.selectedTblProjectsId,
                         "tbl_users_id": ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "",
                         "tbl_forms_id": self.selectedFormsId,
                         "mst_language_id": self.selectedLanguageId,
                         "app_unique_code": appUniqueCode,
                         "tbl_project_phase_id": self.selectedProjectPhaseId,
                         "version": self.selectedversion,
                         "phase": self.selectedphase] as [String : Any]
        
        var tempParentSurveyId = Int()
        var temptblProjectSurveyCommonDataId = String()

        if self.selectedFormsId != 1 && self.selectedFormsId != 4{
            if self.isFromDraft {
                commanDic["parent_survey_id"] = self.modelDraftFormDetails?.parentSurveyId ?? Int()
                tempParentSurveyId = self.modelDraftFormDetails?.parentSurveyId ?? Int()
                temptblProjectSurveyCommonDataId = self.modelDraftFormDetails?.tblProjectSurveyCommonDataId ?? ""
            }
            else {
                commanDic["parent_survey_id"] = self.modelAssignedSurvey?.parentSurveyId ?? ""
                tempParentSurveyId = Int(self.modelAssignedSurvey?.parentSurveyId ?? "") ?? Int()
                temptblProjectSurveyCommonDataId = self.modelAssignedSurvey?.tblProjectSurveyCommonDataId ?? ""
            }
            commanDic["tbl_project_survey_common_data_id"] = temptblProjectSurveyCommonDataId
        }
        else {
            commanDic["parent_survey_id"] = ""
        }
        commanDic["common_question_answer"] = commanQueAnswers
        var arrAnswers = [[String:Any]]()
        for questionGrp in arrFormGroup {
            questionGrp.questions.forEach { question in
                arrAnswers.append(question.toDictionary())
            }
        }
        commanDic["question_answer"] = arrAnswers
        
        if let data = try? JSONSerialization.data(withJSONObject: commanDic, options: .fragmentsAllowed) {
            if self.selectedFormsId != 1 && self.selectedFormsId != 4{
                self.deleteOldForm()
            }
            let query = "insert into tbl_FilledForms (tbl_users_id, tbl_projects_id, mst_language_id, tbl_forms_id, app_unique_code, phase, version, parent_survey_id ,jsonValues, tblProjectPhaseId, tblProjectSurveyCommonDataId) values ('\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")','\(kAppDelegate.selectedProjectID)','\(self.selectedLanguageId)','\(self.selectedFormsId)','\(appUniqueCode)', '\(self.selectedphase)', '\(self.selectedversion)', '\(tempParentSurveyId)' ,'\(String(data: data, encoding: .utf8) ?? "")','\(self.selectedProjectPhaseId)','\(temptblProjectSurveyCommonDataId)')"
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
                    staticQuestion.strAnswer = obj.dateAndTimeOfVisit
                }
                else if staticQuestion.id == 2 {
                    staticQuestion.strAnswer = obj.didThemetPersonAllowedForDat
                }
                else if staticQuestion.id == 3 {
                    staticQuestion.strAnswer = obj.gpsLocation
                }
                else if staticQuestion.id == 4 {
                    staticQuestion.strAnswer = obj.banficaryName
                }
                else if staticQuestion.id == 5 {
                    staticQuestion.strAnswer = obj.mobileNumber
                }
                else if staticQuestion.id == 6 {
                    staticQuestion.strAnswer = obj.doYouHaveAadharCard
                }
                else if staticQuestion.id == 7 {
                    staticQuestion.strAnswer = obj.aadharCard
                }
                else if staticQuestion.id == 8 {
                    staticQuestion.strAnswer = obj.fontPhotoOfAadarCard
                }
                else if staticQuestion.id == 9 {
                    staticQuestion.strAnswer = obj.backPhotoOfAadharCard
                }
                else if staticQuestion.id == 10 {
                    staticQuestion.strAnswer = DataManager.getStataName(stateId: obj.mstStateId)
                }
                else if staticQuestion.id == 11 {
                    staticQuestion.strAnswer = DataManager.getDistrictName(districtId: obj.mstDistrictId)
                }
                else if staticQuestion.id == 12 {
                    staticQuestion.strAnswer = DataManager.getTehsilName(tehsilId: obj.mstTehsilId)
                }
                else if staticQuestion.id == 13 {
                    staticQuestion.strAnswer = DataManager.getVillageName(villageId: obj.mstVillageId)
                }
                else if staticQuestion.id == 14 {
                    staticQuestion.strAnswer = obj.gender
                }
                else if staticQuestion.id == 15 {
                    staticQuestion.strAnswer = obj.familySize
                }
                else if staticQuestion.id == 16 {
                    staticQuestion.strAnswer = obj.familyMemberAbove15Year
                }
                else if staticQuestion.id == 17 {
                    staticQuestion.strAnswer = obj.familyMemberBelow15Year
                }
                else if staticQuestion.id == 18 {
                    staticQuestion.strAnswer = obj.isLpgUsing
                }
                else if staticQuestion.id == 19 {
                    staticQuestion.strAnswer = obj.noOfCylinderPerYear
                }
                else if staticQuestion.id == 20 {
                    staticQuestion.strAnswer = obj.costOfLpgCyliner
                }
                else if staticQuestion.id == 21 {
                    staticQuestion.strAnswer = obj.houseType
                }
                else if staticQuestion.id == 22 {
                    staticQuestion.strAnswer = obj.annualFamilyIncome
                }
                else if staticQuestion.id == 23 {
                    staticQuestion.strAnswer = obj.willingToContributeCleanCooking
                }
                else if staticQuestion.id == 24 {
                    staticQuestion.strAnswer = obj.electricityConnectionAvailable
                }
                else if staticQuestion.id == 25 {
                    staticQuestion.strAnswer = obj.totalElectricityBill
                }
                else if staticQuestion.id == 26 {
                    staticQuestion.strAnswer = obj.frequencyOfbillPayment
                }
                else if staticQuestion.id == 27 {
                    staticQuestion.strAnswer = obj.photoOfBill
                }
                else if staticQuestion.id == 28 {
                    staticQuestion.strAnswer = obj.noOfCattlesOwn
                }
                else if staticQuestion.id == 29 {
                    staticQuestion.strAnswer = obj.doYouHaveRationOrAadhar
                }
                else if staticQuestion.id == 30 {
                    staticQuestion.strAnswer = obj.farmlandIsOwnedByBenficary
                }
                else if staticQuestion.id == 31 {
                    staticQuestion.strAnswer = obj.if5mAreaIsAvailableNearBy
                }
            }
            if self.selectedFormsId == 2 || self.selectedFormsId == 3 {
                self.arrStaticQuestion.append(ModelStaticQuestion(fromDictionary: ["hindi": "",
                                                                                   "id": 32,
                                                                                   "marathi": "",
                                                                                   "option": "",
                                                                                   "question": "Device Serial Number",
                                                                                   "remark": "",
                                                                                   "type": "TEXT",
                                                                                   "answer": "",
                                                                                   "answerId": "",
                                                                                   "strImageBase64": "",
                                                                                   "indexNo": "22"]))
                
                if !self.isFromDraft && self.selectedFormsId == 2{
                    self.arrStaticQuestion.append(ModelStaticQuestion(fromDictionary: ["hindi": "",
                                                                                       "id": 33,
                                                                                       "marathi": "",
                                                                                       "option": "",
                                                                                       "question": "Verify OTP",
                                                                                       "remark": "",
                                                                                       "type": "NUMBER",
                                                                                       "answer": "",
                                                                                       "answerId": "",
                                                                                       "strImageBase64": "",
                                                                                       "indexNo": "23"]))
                }
            }
        }
    }
    
    func sendOTPAPICall() {
        
        let dicParam = ["tbl_users_id": self.selectedTblProjectsId] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kSendVerificationCode, method: .post, parameter: dicParam) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1", let data = responsedic["data"] as? [String:Any], let otp = data["otp"] as? String {
                    self.strOTP = otp
                    self.viewController?.showAlert(with: "Otp send successfully.", firstHandler: { action in
                        self.intOTPTimer = 30
                        self.viewController?.runOTPTimer()
                        self.viewController?.tblQuestion.reloadData()
                    })
                }
                else {
                    self.viewController?.showAlert(with: "Something went wrong.")
                }
            }
        }
    }
}
