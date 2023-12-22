//
//	ModelServerSyncTable.swift
//
//	Create by Dharmil Shiyani on 12/12/2023
//	Copyright © 2023 JS Technovation. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class ModelServerSyncTable{

	var columns : [ModelServerSyncColumn]
	var data : [[String:Any]]
	var tableName : String
	var title : String


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		columns = [ModelServerSyncColumn]()
		if let columnsArray = dictionary["columns"] as? [[String:Any]]{
			for dic in columnsArray{
				let value = ModelServerSyncColumn(fromDictionary: dic)
				columns.append(value)
			}
		}
		data = [[String:Any]]()
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            data = dataArray
        }
		tableName = dictionary["table_name"] as? String ?? ""
		title = dictionary["title"] as? String ?? ""
	}

}
