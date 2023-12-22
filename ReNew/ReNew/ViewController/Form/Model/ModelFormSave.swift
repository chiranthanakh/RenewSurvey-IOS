//
//	ModelFormSaveRootClass.swift
//
//	Create by Dharmil Shiyani on 20/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelFormSave{
    
    var appUniqueCode : String
    var commonQuestionAnswer : ModelFormSaveCommonQuestionAnswer
    var mstLanguageId : String
    var parentSurveyId : String
    var phase : String
    var questionAnswer : [ModelFormSaveQuestionAnswer]
    var tblFormsId : String
    var tblProjectPhaseId : String
    var tblProjectsId : String
    var tblUsersId : String
    var version : String
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        appUniqueCode = dictionary["app_unique_code"] as? String ?? ""
        commonQuestionAnswer = ModelFormSaveCommonQuestionAnswer.init(fromDictionary: [:])
        if let commonQuestionAnswerData = dictionary["common_question_answer"] as? [String:Any]{
            commonQuestionAnswer = ModelFormSaveCommonQuestionAnswer(fromDictionary: commonQuestionAnswerData)
        }
        mstLanguageId = dictionary["mst_language_id"] as? String ?? ""
        parentSurveyId = dictionary["parent_survey_id"] as? String ?? ""
        phase = dictionary["phase"] as? String ?? ""
        questionAnswer = [ModelFormSaveQuestionAnswer]()
        if let questionAnswerArray = dictionary["question_answer"] as? [[String:Any]]{
            for dic in questionAnswerArray{
                let value = ModelFormSaveQuestionAnswer(fromDictionary: dic)
                questionAnswer.append(value)
            }
        }
        tblFormsId = dictionary["tbl_forms_id"] as? String ?? ""
        tblProjectPhaseId = dictionary["tbl_project_phase_id"] as? String ?? ""
        tblProjectsId = dictionary["tbl_projects_id"] as? String ?? ""
        tblUsersId = dictionary["tbl_users_id"] as? String ?? ""
        version = dictionary["version"] as? String ?? ""
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["app_unique_code"] = appUniqueCode
        dictionary["common_question_answer"] = commonQuestionAnswer.toDictionary()
        dictionary["mst_language_id"] = mstLanguageId
        dictionary["parent_survey_id"] = parentSurveyId
        dictionary["phase"] = phase
        var dictionaryElements = [[String:Any]]()
        for questionAnswerElement in questionAnswer {
            dictionaryElements.append(questionAnswerElement.toDictionary())
        }
        dictionary["question_answer"] = dictionaryElements
        dictionary["tbl_forms_id"] = tblFormsId
        dictionary["tbl_project_phase_id"] = tblProjectPhaseId
        dictionary["tbl_projects_id"] = tblProjectsId
        dictionary["tbl_users_id"] = tblUsersId
        dictionary["version"] = version
        return dictionary
    }
}
