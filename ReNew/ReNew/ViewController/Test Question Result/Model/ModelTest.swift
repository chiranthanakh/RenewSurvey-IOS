//
//	ModelTest.swift
//
//	Create by Dharmil Shiyani on 28/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelTest {
    
    var createDate : String
    var createdBy : Int
    var isActive : Int
    var isDelete : Int
    var lastUpdate : String
    var passingMarks : String
    var tblFormsId : Int
    var tblTestsId : Int
    var testCode : String
    var title : String
    var question : [ModelTestQuestion]
    var tutorial: String
    var projectId : Int
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createDate = dictionary["create_date"] as? String ?? ""
        createdBy = dictionary["created_by"] as? Int ?? Int()
        isActive = dictionary["is_active"] as? Int ?? Int()
        isDelete = dictionary["is_delete"] as? Int ?? Int()
        lastUpdate = dictionary["last_update"] as? String ?? ""
        passingMarks = dictionary["passing_marks"] as? String ?? ""
        tblFormsId = dictionary["tbl_forms_id"] as? Int ?? Int()
        tblTestsId = dictionary["tbl_tests_id"] as? Int ?? Int()
        testCode = dictionary["test_code"] as? String ?? ""
        title = dictionary["title"] as? String ?? ""
        tutorial = dictionary["tutorial"] as? String ?? ""
        projectId = dictionary["projectId"] as? Int ?? Int()
        question = [ModelTestQuestion]()
        if let questionOptionArray = dictionary["question"] as? [[String:Any]]{
            for dic in questionOptionArray{
                let value = ModelTestQuestion(fromDictionary: dic)
                question.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["create_date"] = createDate
        dictionary["created_by"] = createdBy
        dictionary["is_active"] = isActive
        dictionary["is_delete"] = isDelete
        dictionary["last_update"] = lastUpdate
        dictionary["passing_marks"] = passingMarks
        dictionary["tbl_forms_id"] = tblFormsId
        dictionary["tbl_tests_id"] = tblTestsId
        dictionary["test_code"] = testCode
        dictionary["title"] = title
        var dictionaryElements = [[String:Any]]()
        for questionOptionElement in question {
            dictionaryElements.append(questionOptionElement.toDictionary())
        }
        dictionary["question"] = dictionaryElements
        dictionary["tutorial"] = tutorial
        dictionary["projectId"] = projectId
        return dictionary
    }
    
}
