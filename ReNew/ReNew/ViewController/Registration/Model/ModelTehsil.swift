//
//	ModelTehsil.swift
//
//	Create by Dharmil Shiyani on 9/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelTehsil{

	var mstTehsilId : String
	var tehsilName : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstTehsilId = dictionary["mst_tehsil_id"] as? String ?? ""
        tehsilName = dictionary["tehsil_name"] as? String  ?? ""
	}

}
