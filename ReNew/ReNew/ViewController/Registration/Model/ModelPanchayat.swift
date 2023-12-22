//
//	ModelPanchayat.swift
//
//	Create by Dharmil Shiyani on 9/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelPanchayat{

	var mstPanchayatId : String
	var panchayatName : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstPanchayatId = dictionary["mst_panchayat_id"] as? String ?? ""
		panchayatName = dictionary["panchayat_name"] as? String ?? ""
	}

}
