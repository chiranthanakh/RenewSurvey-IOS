//
//	ModelServerSyncColumn.swift
//
//	Create by Dharmil Shiyani on 12/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelServerSyncColumn{

	var defaultField : String
	var extra : String
	var field : String
	var key : String
	var nullField : String
	var type : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		defaultField = dictionary["default"] as? String ?? ""
		extra = dictionary["extra"] as? String ?? ""
		field = dictionary["field"] as? String ?? ""
		key = dictionary["key"] as? String ?? ""
		nullField = dictionary["null"] as? String ?? ""
		type = dictionary["type"] as? String ?? ""
	}

}
