//
//	ModelFormSaveCommonQuestionAnswer.swift
//
//	Create by Dharmil Shiyani on 20/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelFormSaveCommonQuestionAnswer {

	var aadharCard : String
	var annualFamilyIncome : String
	var banficaryName : String
	var electricityConnectionAvailable : String
	var familySize : String
	var gender : String
	var houseType : String
	var isCowDung : String
	var isLpgUsing : String
	var mobileNumber : String
	var mstDistrictId : String
	var mstStateId : String
	var mstTehsilId : String
	var mstVillageId : String
	var noOfCattlesOwn : String
	var noOfCowDungPerDay : String
	var noOfCylinderPerYear : String
	var willingToContributeCleanCooking : String
	var woodUsePerDayInKg : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		aadharCard = dictionary["aadhar_card"] as? String ?? ""
		annualFamilyIncome = dictionary["annual_family_income"] as? String ?? ""
		banficaryName = dictionary["banficary_name"] as? String ?? ""
		electricityConnectionAvailable = dictionary["electricity_connection_available"] as? String ?? ""
		familySize = dictionary["family_size"] as? String ?? ""
		gender = dictionary["gender"] as? String ?? ""
		houseType = dictionary["house_type"] as? String ?? ""
		isCowDung = dictionary["is_cow_dung"] as? String ?? ""
		isLpgUsing = dictionary["is_lpg_using"] as? String ?? ""
		mobileNumber = dictionary["mobile_number"] as? String ?? ""
		mstDistrictId = dictionary["mst_district_id"] as? String ?? ""
		mstStateId = dictionary["mst_state_id"] as? String ?? ""
		mstTehsilId = dictionary["mst_tehsil_id"] as? String ?? ""
		mstVillageId = dictionary["mst_village_id"] as? String ?? ""
		noOfCattlesOwn = dictionary["no_of_cattles_own"] as? String ?? ""
		noOfCowDungPerDay = dictionary["no_of_cow_dung_per_day"] as? String ?? ""
		noOfCylinderPerYear = dictionary["no_of_cylinder_per_year"] as? String ?? ""
		willingToContributeCleanCooking = dictionary["willing_to_contribute_clean_cooking"] as? String ?? ""
		woodUsePerDayInKg = dictionary["wood_use_per_day_in_kg"] as? String ?? ""
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        dictionary["aadhar_card"] = aadharCard
        dictionary["annual_family_income"] = annualFamilyIncome
        dictionary["banficary_name"] = banficaryName
        dictionary["electricity_connection_available"] = electricityConnectionAvailable
        dictionary["family_size"] = familySize
        dictionary["gender"] = gender
        dictionary["house_type"] = houseType
        dictionary["is_cow_dung"] = isCowDung
        dictionary["is_lpg_using"] = isLpgUsing
        dictionary["mobile_number"] = mobileNumber
        dictionary["mst_district_id"] = mstDistrictId
        dictionary["mst_state_id"] = mstStateId
        dictionary["mst_tehsil_id"] = mstTehsilId
        dictionary["mst_village_id"] = mstVillageId
        dictionary["no_of_cattles_own"] = noOfCattlesOwn
        dictionary["no_of_cow_dung_per_day"] = noOfCowDungPerDay
        dictionary["no_of_cylinder_per_year"] = noOfCylinderPerYear
        dictionary["willing_to_contribute_clean_cooking"] = willingToContributeCleanCooking
        dictionary["wood_use_per_day_in_kg"] = woodUsePerDayInKg
        return dictionary
    }


}
