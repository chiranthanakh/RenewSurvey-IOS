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

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["mst_question_group_id"] = mstQuestionGroupId
        dictionary["title"] = title
        
        if questions != nil{
            var dictionaryElements = [[String:Any]]()
            for optionsElement in questions {
                dictionaryElements.append(optionsElement.toDictionary())
            }
            dictionary["questions"] = dictionaryElements
        }
        return dictionary
    }
}


class ModelFormDraft{

    var staticQuestions : [ModelStaticQuestion]
    var grpForm : [ModelFormGroup]


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        staticQuestions = [ModelStaticQuestion]()
        if let questionsArray = dictionary["staticQuestions"] as? [[String:Any]]{
            for dic in questionsArray{
                let value = ModelStaticQuestion(fromDictionary: dic)
                staticQuestions.append(value)
            }
        }
        
        grpForm = [ModelFormGroup]()
        if let questionsArray = dictionary["questions"] as? [[String:Any]]{
            for dic in questionsArray{
                let value = ModelFormGroup(fromDictionary: dic)
                grpForm.append(value)
            }
        }
    }

    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        var dictionaryStaticQueElements = [[String:Any]]()
        for questionAnswerElement in staticQuestions {
            dictionaryStaticQueElements.append(questionAnswerElement.toDictionary())
        }
        dictionary["staticQuestions"] = dictionaryStaticQueElements
        
        var dictionaryElements = [[String:Any]]()
        for questionAnswerElement in grpForm {
            dictionaryElements.append(questionAnswerElement.toDictionary())
        }
        dictionary["questions"] = dictionaryElements

        return dictionary
    }
}
