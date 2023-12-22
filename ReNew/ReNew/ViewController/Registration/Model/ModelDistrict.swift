//
//	ModelDistrict.swift
//
//	Create by Dharmil Shiyani on 9/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelDistrict{

	var districtName : String!
	var mstDistrictId : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		districtName = dictionary["district_name"] as? String
		mstDistrictId = dictionary["mst_district_id"] as? String
	}

}