//
//	ModelFormGroup.swift
//
//	Create by Dharmil Shiyani on 14/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelFormGroup{

	var mstQuestionGroupId : Int
	var title : String
    var questions : [ModelQuestion]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstQuestionGroupId = dictionary["mst_question_group_id"] as? Int ?? 0
		title = dictionary["title"] as? String ?? ""
        questions = [ModelQuestion]()
        if let questionsArray = dictionary["questions"] as? [[String:Any]]{
            for dic in questionsArray{
                let value = ModelQuestion(fromDictionary: dic)
                questions.append(value)
            }
        }
	}

}
