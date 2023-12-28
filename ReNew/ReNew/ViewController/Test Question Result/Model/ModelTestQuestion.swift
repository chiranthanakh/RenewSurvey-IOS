//
//	ModelTestQuestion.swift
//
//	Create by Dharmil Shiyani on 28/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelTestQuestion {

	var answer : String
	var createDate : String
	var createdBy : Int
	var format : String
	var isActive : Int
	var isDelete : Int
	var isMandatory : String
	var isSpecialCharAllowed : String
	var isValidationRequired : String
	var lastUpdate : String
	var maxLength : Int
	var minLength : Int
	var orderBy : Int
	var questionOption : [ModelTestQuestionOption]
	var questionType : String
	var tblFormsId : Int
	var tblTestQuestionsId : Int
	var tblTestsId : Int
    var title : String
    var userAnswer: String
    

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String ?? ""
        answer = dictionary["answer"] as? String ?? ""
		createDate = dictionary["create_date"] as? String ?? ""
		createdBy = dictionary["created_by"] as? Int ?? Int()
		format = dictionary["format"] as? String ?? ""
		isActive = dictionary["is_active"] as? Int ?? Int()
		isDelete = dictionary["is_delete"] as? Int ?? Int()
		isMandatory = dictionary["is_mandatory"] as? String ?? ""
		isSpecialCharAllowed = dictionary["is_special_char_allowed"] as? String ?? ""
		isValidationRequired = dictionary["is_validation_required"] as? String ?? ""
		lastUpdate = dictionary["last_update"] as? String ?? ""
		maxLength = dictionary["max_length"] as? Int ?? Int()
		minLength = dictionary["min_length"] as? Int ?? Int()
		orderBy = dictionary["order_by"] as? Int ?? Int()
		questionOption = [ModelTestQuestionOption]()
		if let questionOptionArray = dictionary["questionOption"] as? [[String:Any]]{
			for dic in questionOptionArray{
				let value = ModelTestQuestionOption(fromDictionary: dic)
				questionOption.append(value)
			}
		}
		questionType = dictionary["question_type"] as? String ?? ""
		tblFormsId = dictionary["tbl_forms_id"] as? Int ?? Int()
		tblTestQuestionsId = dictionary["tbl_test_questions_id"] as? Int ?? Int()
		tblTestsId = dictionary["tbl_tests_id"] as? Int ?? Int()
        userAnswer = dictionary["userAnswer"] as? String ?? ""
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["title"] = title
        dictionary["answer"] = answer
        dictionary["create_date"] = createDate
        dictionary["created_by"] = createdBy
        dictionary["format"] = format
        dictionary["is_active"] = isActive
        dictionary["is_delete"] = isDelete
        dictionary["is_mandatory"] = isMandatory
        dictionary["is_special_char_allowed"] = isSpecialCharAllowed
        dictionary["is_validation_required"] = isValidationRequired
        dictionary["last_update"] = lastUpdate
        dictionary["max_length"] = maxLength
        dictionary["min_length"] = minLength
        dictionary["order_by"] = orderBy
        var dictionaryElements = [[String:Any]]()
        for questionOptionElement in questionOption {
            dictionaryElements.append(questionOptionElement.toDictionary())
        }
        dictionary["questionOption"] = dictionaryElements
        dictionary["question_type"] = questionType
        dictionary["tbl_forms_id"] = tblFormsId
        dictionary["tbl_test_questions_id"] = tblTestQuestionsId
        dictionary["tbl_tests_id"] = tblTestsId
        dictionary["userAnswer"] = userAnswer
        return dictionary
    }

}
