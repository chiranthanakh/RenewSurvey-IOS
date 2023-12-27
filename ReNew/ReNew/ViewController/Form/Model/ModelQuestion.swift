//
//	ModelQuestion.swift
//
//	Create by Dharmil Shiyani on 14/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelQuestion{

	var questionType : String
	var tblFormQuestionsId : Int
	var title : String
    var questionOption : [ModelQuestionOption]!
    var strAnswer : String
    var allowFileType: String
    var mstQuestionGroupId : Int
    var minLength : Int
    var maxLength : Int
    var tblProjectPhaseId : Int
    var version : Int
    var imageAnswer = UIImage()
    var strImageBase64 : String
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		questionType = dictionary["question_type"] as? String ?? ""
		tblFormQuestionsId = dictionary["tbl_form_questions_id"] as? Int ?? 0
		title = dictionary["title"] as? String ?? ""
        allowFileType = dictionary["allowed_file_type"] as? String ?? ""
        questionOption = [ModelQuestionOption]()
        if let questionOptionArray = dictionary["question_Option"] as? [[String:Any]]{
            for dic in questionOptionArray{
                let value = ModelQuestionOption(fromDictionary: dic)
                questionOption.append(value)
            }
        }
        mstQuestionGroupId = dictionary["mst_question_group_id"] as? Int ?? 0
        strAnswer = dictionary["answer"] as? String ?? ""
        version = dictionary["version"] as? Int ?? 0
        tblProjectPhaseId = dictionary["tbl_project_phase_id"] as? Int ?? 0
        strImageBase64 = dictionary["strImageBase64"] as? String ?? ""
        minLength = dictionary["minLength"] as? Int ?? 0
        maxLength = dictionary["maxLength"] as? Int ?? 0
	}

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["tbl_form_questions_id"] = tblFormQuestionsId
        dictionary["mst_question_group_id"] = mstQuestionGroupId
        dictionary["question_type"] = questionType
        dictionary["title"] = title
        dictionary["allowed_file_type"] = allowFileType
        dictionary["answer"] = strAnswer
        dictionary["maxLength"] = maxLength
        dictionary["minLength"] = minLength
        if questionType == "CAPTURE" {
            if let imageData:NSData = self.imageAnswer.jpegData(compressionQuality: 0.6) as NSData?  {
                dictionary["strImageBase64"] = imageData.base64EncodedString(options: .lineLength64Characters)
                dictionary["answer"] = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedProjectID)_\(kAppDelegate.selectedFormID)_\(String(Date().timeIntervalSince1970)).jpeg"
            }
        }
        else if questionType == "FILE" {
            print(strAnswer)
        }
        dictionary["version"] = version
        dictionary["tbl_project_phase_id"] = tblProjectPhaseId
        dictionary["phase"] = kAppDelegate.selectedForm?.phase ?? ""
        
        if questionOption != nil{
            var dictionaryElements = [[String:Any]]()
            for optionsElement in questionOption {
                dictionaryElements.append(optionsElement.toDictionary())
            }
            dictionary["question_Option"] = dictionaryElements
        }
        return dictionary
    }
    
}
