//
//	ModelUserRole.swift
//
//	Create by Dharmil Shiyani on 13/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelUserRole{

	var mstFormLanguageId : Int
	var tblFormsId : Int
	var title : String
    var tblProjectsId: Int
    var formName : String
    var tblProjectPhaseId : Int
    var phase: Int
    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstFormLanguageId = dictionary["mst_form_language_id"] as? Int ?? 0
		tblFormsId = dictionary["tbl_forms_id"] as? Int ?? 0
		title = dictionary["title"] as? String ?? ""
        tblProjectsId = dictionary["tbl_projects_id"] as? Int ?? 0
        formName = dictionary["form_name"] as? String ?? ""
        tblProjectPhaseId = dictionary["tbl_project_phase_id"] as? Int ?? 0
        phase = dictionary["phase"] as? Int ?? 0
	}

}
