//
//	ModelLanguage.swift
//
//	Create by Dharmil Shiyani on 12/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelLanguage{

	var mstLanguageId : Int
	var symbol : String
	var title : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstLanguageId = dictionary["mst_language_id"] as? Int ?? 0
		symbol = dictionary["symbol"] as? String ?? ""
		title = dictionary["title"] as? String ?? ""
	}

}
