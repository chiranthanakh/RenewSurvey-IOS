//
//	ModelUserRole.swift
//
//	Create by Dharmil Shiyani on 13/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelUserRole{

	var mstFormLanguageId : Int
	var tblFormsId : Int
	var title : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstFormLanguageId = dictionary["mst_form_language_id"] as? Int ?? 0
		tblFormsId = dictionary["tbl_forms_id"] as? Int ?? 0
		title = dictionary["title"] as? String ?? ""
	}

}
