//
//	ModelStaticQuestion.swift
//
//	Create by Dharmil Shiyani on 18/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelStaticQuestion{

	var hindi : String
	var id : Int
	var marathi : String
	var option : String
	var question : String
	var remark : String
	var type : String
    var strAnswer = String()
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		hindi = dictionary["hindi"] as? String ?? ""
		id = dictionary["id"] as? Int ?? 0
		marathi = dictionary["marathi"] as? String ?? ""
		option = dictionary["option"] as? String ?? ""
		question = dictionary["question"] as? String ?? ""
		remark = dictionary["remark"] as? String ?? ""
		type = dictionary["type"] as? String ?? ""
	}

    func questiontitle() -> String {
        if kAppDelegate.selectedLanguageID == 2 {
            return hindi
        }
        else {
            return question
        }
    }
}
