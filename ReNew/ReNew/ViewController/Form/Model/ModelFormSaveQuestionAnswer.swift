//
//	ModelFormSaveQuestionAnswer.swift
//
//	Create by Dharmil Shiyani on 20/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelFormSaveQuestionAnswer{

	var answer : String
	var mstQuestionGroupId : String
	var tblFormQuestionsId : String

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		answer = dictionary["answer"] as? String ?? ""
		mstQuestionGroupId = dictionary["mst_question_group_id"] as? String ?? ""
		tblFormQuestionsId = dictionary["tbl_form_questions_id"] as? String ?? ""
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
			dictionary["answer"] = answer
			dictionary["mst_question_group_id"] = mstQuestionGroupId
			dictionary["tbl_form_questions_id"] = tblFormQuestionsId
		return dictionary
	}

}
