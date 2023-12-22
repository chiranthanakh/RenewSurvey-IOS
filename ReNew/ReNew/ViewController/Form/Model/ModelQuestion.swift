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
    var strAnswer = String()
    var allowFileType: String
    var minLength = Int()
    var maxLength = Int()

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
	}

}
