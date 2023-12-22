//
//	ModelAsyncForm.swift
//
//	Create by Dharmil Shiyani on 20/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelAsyncForm{

	var appUniqueCode : String
	var id : Int
	var jsonValues : String
	var mstLanguageId : Int
	var status : Int
	var tblFormsId : Int
	var tblProjectPhaseId : Int
	var tblProjectsId : Int
	var tblUsersId : Int
    var parentSurveyId: Int

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		appUniqueCode = dictionary["app_unique_code"] as? String ?? ""
		id = dictionary["id"] as? Int ?? Int()
		jsonValues = dictionary["jsonValues"] as? String ?? ""
		mstLanguageId = dictionary["mst_language_id"] as? Int ?? Int()
		status = dictionary["status"] as? Int ?? Int()
		tblFormsId = dictionary["tbl_forms_id"] as? Int  ?? Int()
		tblProjectPhaseId = dictionary["tbl_project_phase_id"] as? Int  ?? Int()
		tblProjectsId = dictionary["tbl_projects_id"] as? Int ?? Int()
		tblUsersId = dictionary["tbl_users_id"] as? Int ?? Int()
        parentSurveyId = dictionary[ "parent_survey_id"] as? Int ?? Int()
	}

}
