//
//	ModelProject.swift
//
//	Create by Dharmil Shiyani on 13/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelProject{

	var mstCategoriesId : String
	var mstDivisionsId : String
	var projectCoOrdinator : String
	var projectCode : String
	var projectManager : String
	var tblProjectsId : Int
    var title : String

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		mstCategoriesId = dictionary["mst_categories_id"] as? String ?? ""
		mstDivisionsId = dictionary["mst_divisions_id"] as? String ?? ""
		projectCoOrdinator = dictionary["project_co_ordinator"] as? String ?? ""
		projectCode = dictionary["project_code"] as? String ?? ""
		projectManager = dictionary["project_manager"] as? String ?? ""
		tblProjectsId = dictionary["tbl_projects_id"] as? Int ?? 0
        title = dictionary["title"] as? String ?? ""
	}

}
