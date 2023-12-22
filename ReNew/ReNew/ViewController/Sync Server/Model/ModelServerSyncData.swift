//
//	ModelServerSyncData.swift
//
//	Create by Dharmil Shiyani on 12/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelServerSyncData{

	var createDate : String
	var createdBy : String
	var isActive : String
	var isDelete : String
	var lastUpdate : String
	var mstCountryId : String
	var mstStateId : String
	var stateCode : String
	var stateName : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		createDate = dictionary["create_date"] as? String ?? ""
		createdBy = dictionary["created_by"] as? String ?? ""
		isActive = dictionary["is_active"] as? String ?? ""
		isDelete = dictionary["is_delete"] as? String ?? ""
		lastUpdate = dictionary["last_update"] as? String ?? ""
		mstCountryId = dictionary["mst_country_id"] as? String ?? ""
		mstStateId = dictionary["mst_state_id"] as? String ?? ""
		stateCode = dictionary["state_code"] as? String ?? ""
		stateName = dictionary["state_name"] as? String ?? ""
	}

}
