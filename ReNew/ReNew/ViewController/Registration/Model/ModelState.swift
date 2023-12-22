//
//	ModelState.swift
//
//	Create by Dharmil Shiyani on 9/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelState{

	var mstStateId : String
	var stateName : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstStateId = dictionary["mst_state_id"] as? String ?? ""
		stateName = dictionary["state_name"] as? String  ?? ""
	}

}
