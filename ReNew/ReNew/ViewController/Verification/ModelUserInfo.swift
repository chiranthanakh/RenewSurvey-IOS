//
//	ModelUserInfo.swift
//
//	Create by Dharmil Shiyani on 14/2/2024
//	Copyright © 2024 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelUserInfo{

	var aadharCard : String
	var address : String
	var altMoile : String
	var dateOfBirth : String
	var email : String
	var fullName : String
	var gender : String
	var mobile : String
	var mstDistrictId : String
	var mstPanchayatId : String
	var mstStateId : String
	var mstTehsilId : String
	var mstVillageId : String
	var pincode : String
	var profilePhoto : String
	var username : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		aadharCard = dictionary["aadhar_card"] as? String ?? ""
		address = dictionary["address"] as? String ?? ""
		altMoile = dictionary["alt_moile"] as? String ?? ""
		dateOfBirth = dictionary["date_of_birth"] as? String ?? ""
		email = dictionary["email"] as? String ?? ""
		fullName = dictionary["full_name"] as? String ?? ""
		gender = dictionary["gender"] as? String ?? ""
		mobile = dictionary["mobile"] as? String ?? ""
		mstDistrictId = dictionary["mst_district_id"] as? String ?? ""
		mstPanchayatId = dictionary["mst_panchayat_id"] as? String ?? ""
		mstStateId = dictionary["mst_state_id"] as? String ?? ""
		mstTehsilId = dictionary["mst_tehsil_id"] as? String ?? ""
		mstVillageId = dictionary["mst_village_id"] as? String ?? ""
		pincode = dictionary["pincode"] as? String ?? ""
		profilePhoto = dictionary["profile_photo"] as? String ?? ""
		username = dictionary["username"] as? String ?? ""
	}

}
