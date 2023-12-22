//
//	ModelAssignedSurvey.swift
//
//	Create by Dharmil Shiyani on 22/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ModelAssignedSurvey {
    
    var aadharCard : String
    var annualFamilyIncome : String
    var appUniqueCode : String
    var banficaryName : String
    var electricityConnectionAvailable : String
    var familySize : String
    var gender : String
    var houseType : String
    var isCowDung : String
    var isLpgUsing : String
    var mobileNumber : String
    var mstDistrictId : String
    var mstPanchayatId : String
    var mstStateId : String
    var mstTehsilId : String
    var mstVillageId : String
    var nextFormId : String
    var noOfCattlesOwn : String
    var noOfCowDungPerDay : String
    var noOfCylinderPerYear : String
    var parentSurveyId : String
    var reason : String
    var systemApproval : String
    var tblProjectSurveyCommonDataId : String
    var tblProjectsId : String
    var willingToContributeCleanCooking : String
    var woodUsePerDayInKg : String
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        aadharCard = dictionary["aadhar_card"] as? String ?? ""
        annualFamilyIncome = dictionary["annual_family_income"] as? String ?? ""
        appUniqueCode = dictionary["app_unique_code"] as? String ?? ""
        banficaryName = dictionary["banficary_name"] as? String ?? ""
        electricityConnectionAvailable = dictionary["electricity_connection_available"] as? String ?? ""
        familySize = dictionary["family_size"] as? String ?? ""
        gender = dictionary["gender"] as? String ?? ""
        houseType = dictionary["house_type"] as? String ?? ""
        isCowDung = dictionary["is_cow_dung"] as? String ?? ""
        isLpgUsing = dictionary["is_lpg_using"] as? String ?? ""
        mobileNumber = dictionary["mobile_number"] as? String ?? ""
        mstDistrictId = dictionary["mst_district_id"] as? String ?? ""
        mstPanchayatId = dictionary["mst_panchayat_id"] as? String ?? ""
        mstStateId = dictionary["mst_state_id"] as? String ?? ""
        mstTehsilId = dictionary["mst_tehsil_id"] as? String ?? ""
        mstVillageId = dictionary["mst_village_id"] as? String ?? ""
        nextFormId = dictionary["next_form_id"] as? String ?? ""
        noOfCattlesOwn = dictionary["no_of_cattles_own"] as? String ?? ""
        noOfCowDungPerDay = dictionary["no_of_cow_dung_per_day"] as? String ?? ""
        noOfCylinderPerYear = dictionary["no_of_cylinder_per_year"] as? String ?? ""
        parentSurveyId = dictionary["parent_survey_id"] as? String ?? ""
        reason = dictionary["reason"] as? String ?? ""
        systemApproval = dictionary["system_approval"] as? String ?? ""
        tblProjectSurveyCommonDataId = dictionary["tbl_project_survey_common_data_id"] as? String ?? ""
        tblProjectsId = dictionary["tbl_projects_id"] as? String ?? ""
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
        dictionary["app_unique_code"] = appUniqueCode
        dictionary["banficary_name"] = banficaryName
        dictionary["electricity_connection_available"] = electricityConnectionAvailable
        dictionary["family_size"] = familySize
        dictionary["gender"] = gender
        dictionary["house_type"] = houseType
        dictionary["is_cow_dung"] = isCowDung
        dictionary["is_lpg_using"] = isLpgUsing
        dictionary["mobile_number"] = mobileNumber
        dictionary["mst_district_id"] = mstDistrictId
        dictionary["mst_panchayat_id"] = mstPanchayatId
        dictionary["mst_state_id"] = mstStateId
        dictionary["mst_tehsil_id"] = mstTehsilId
        dictionary["mst_village_id"] = mstVillageId
        dictionary["next_form_id"] = nextFormId
        dictionary["no_of_cattles_own"] = noOfCattlesOwn
        dictionary["no_of_cow_dung_per_day"] = noOfCowDungPerDay
        dictionary["no_of_cylinder_per_year"] = noOfCylinderPerYear
        dictionary["parent_survey_id"] = parentSurveyId
        dictionary["reason"] = reason
        dictionary["system_approval"] = systemApproval
        dictionary["tbl_project_survey_common_data_id"] = tblProjectSurveyCommonDataId
        dictionary["tbl_projects_id"] = tblProjectsId
        dictionary["willing_to_contribute_clean_cooking"] = willingToContributeCleanCooking
        dictionary["wood_use_per_day_in_kg"] = woodUsePerDayInKg
        return dictionary
    }
    
}
