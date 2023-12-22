//
//	ModelQuestionOption.swift
//
//	Create by Dharmil Shiyani on 14/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelQuestionOption{

	var tblFormQuestionsOptionId : Int!
	var title : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		tblFormQuestionsOptionId = dictionary["tbl_form_questions_option_id"] as? Int
		title = dictionary["title"] as? String
	}

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["tbl_form_questions_option_id"] = tblFormQuestionsOptionId
        dictionary["title"] = title
        return dictionary
    }
}
