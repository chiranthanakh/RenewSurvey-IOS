//
//	ModelTestQuestionOption.swift
//
//	Create by Dharmil Shiyani on 28/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelTestQuestionOption {
    
    var title: String
    var createDate : String
    var createdBy : Int
    var isActive : Int
    var isAnswer : String
    var isDelete : Int
    var lastUpdate : String
    var tblFormsId : Int
    var tblTestQuestionsId : Int
    var tblTestQuestionsOptionId : Int
    var tblTestsId : Int
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String ?? ""
        createDate = dictionary["create_date"] as? String ?? ""
        createdBy = dictionary["created_by"] as? Int ?? Int()
        isActive = dictionary["is_active"] as? Int ?? Int()
        isAnswer = dictionary["is_answer"] as? String ?? ""
        isDelete = dictionary["is_delete"] as? Int ?? Int()
        lastUpdate = dictionary["last_update"] as? String ?? ""
        tblFormsId = dictionary["tbl_forms_id"] as? Int ?? Int()
        tblTestQuestionsId = dictionary["tbl_test_questions_id"] as? Int ?? Int()
        tblTestQuestionsOptionId = dictionary["tbl_test_questions_option_id"] as? Int ?? Int()
        tblTestsId = dictionary["tbl_tests_id"] as? Int ?? Int()
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["title"] = title
        dictionary["create_date"] = createDate
        dictionary["created_by"] = createdBy
        dictionary["is_active"] = isActive
        dictionary["is_answer"] = isAnswer
        dictionary["is_delete"] = isDelete
        dictionary["last_update"] = lastUpdate
        dictionary["tbl_forms_id"] = tblFormsId
        dictionary["tbl_test_questions_id"] = tblTestQuestionsId
        dictionary["tbl_test_questions_option_id"] = tblTestQuestionsOptionId
        dictionary["tbl_tests_id"] = tblTestsId
        return dictionary
    }
    
}
