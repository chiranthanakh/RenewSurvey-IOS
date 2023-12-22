//
//	ModelVillage.swift
//
//	Create by Dharmil Shiyani on 11/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelVillage{

	var mstVillagesId : String
	var villageName : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstVillagesId = dictionary["mst_villages_id"] as? String ?? ""
		villageName = dictionary["village_name"] as? String ?? ""
	}

}
