//
//  SyncServerVC.swift
//  ReNew
//
//  Created by Shiyani on 12/12/23.
//

import UIKit

class SyncServerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnSyncData(_ sender: UIButton) {
        self.callSyncAPI()
    }
}

//MARK: - Init Config
extension SyncServerVC {
    
    private func initConfig() {
        
    }
 
    func callSyncAPI() {
        let param = ["app_key": AppConstant.Key.appKey,
                     "tbl_users_id": ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? ""] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kSyncDataFromServer, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    if let data = responsedic["data"] as? [String:Any] {
                        if let tables = data["tables"] as? [[String:Any]] {
                            self.tableDataUpdate(tables: tables.compactMap(ModelServerSyncTable.init))
                        }
                        if let assignedSurvey = data["assigned_survey"] as? [[String:Any]] {
                            self.assignedSurveyDataSaveToLocalDb(arrAssignedSurvey: assignedSurvey)
                        }
                    }
                }
                else {
                    self.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    
    func tableDataUpdate(tables: [ModelServerSyncTable]) {
        for table in tables {
            if !DataManager.checkIfTableExist(strTblName: table.tableName) {
                self.createTable(tableData: table)
            }
            else {
                self.tableDataBind(tableData: table)
            }
        }
        UserDefaults.kLastAsyncDate = Date().getFormattedString(format: "dd-MM-yyyy")
        self.navigationController?.pushViewController(LanguageSelectionVC(), animated: true)
    }
    
    func createTable(tableData: ModelServerSyncTable) {
        var strQueary = "CREATE TABLE \(tableData.tableName)("
        for i in 0..<tableData.columns.count{
            strQueary.append("\(tableData.columns[i].field)")
            if tableData.columns[i].type == "int" || tableData.columns[i].type == "tinyint(1)" {
                strQueary.append(" INTEGER")
            }
            else if tableData.columns[i].type.contains("varchar") || tableData.columns[i].type == "enum('Y','N')" {
                strQueary.append(" TEXT")
            }
            else if tableData.columns[i].type.contains("timestamp") {
                strQueary.append(" TIMESTAMP")
            }
            if tableData.columns[i].nullField == "NO" {
                strQueary.append(" NOT NULL")
            }
            if tableData.columns[i].key == "PRI" {
                strQueary.append(" PRIMARY KEY")
            }
            if tableData.columns[i].defaultField != "" {
                strQueary.append(" DEFAULT '\(tableData.columns[i].defaultField)'")
            }
            if tableData.columns[i].extra == "auto_increment" {
                strQueary.append(" AUTOINCREMENT")
            }
            if i < tableData.columns.count-1 {
                strQueary.append(",")
            }
            
        }
        strQueary.append(")")
       
        if DataManager.DML(query: strQueary) == true {
            print("Inserted")
            self.tableDataBind(tableData: tableData)
        }
        else {
            print(strQueary)
        }
    }
    
    func tableDataBind(tableData: ModelServerSyncTable) {
        for item in 0..<tableData.data.count {
            var strQueary = "insert into \(tableData.tableName)("
            let keyArr = Array(tableData.data[item].keys).map { String($0) }
            for itemKey in 0..<keyArr.count {
                strQueary.append("\(keyArr[itemKey])")
                if itemKey < keyArr.count-1 {
                    strQueary.append(", ")
                }
            }
            strQueary.append(")values(")
            for itemKey in 0..<keyArr.count {
                strQueary.append("'\(tableData.data[item][keyArr[itemKey]] ?? "")'")
                if itemKey < keyArr.count-1 {
                    strQueary.append(", ")
                }
            }
            
            strQueary.append(")")
            if DataManager.DML(query: strQueary) == true {
                print("Inserted")
            }
            else {
                print("Error \(strQueary)")
            }
        }
    }
    
    func assignedSurveyDataSaveToLocalDb(arrAssignedSurvey: [[String:Any]]) {
        for item in 0..<arrAssignedSurvey.count {
            var strQueary = "insert into tbl_assigned_survey("
            let keyArr = Array(arrAssignedSurvey[item].keys).map { String($0) }
            for itemKey in 0..<keyArr.count {
                strQueary.append("\(keyArr[itemKey])")
                if itemKey < keyArr.count-1 {
                    strQueary.append(", ")
                }
            }
            strQueary.append(")values(")
            for itemKey in 0..<keyArr.count {
                strQueary.append("'\(arrAssignedSurvey[item][keyArr[itemKey]] ?? "")'")
                if itemKey < keyArr.count-1 {
                    strQueary.append(", ")
                }
            }
            
            strQueary.append(")")
            if DataManager.DML(query: strQueary) == true {
                print("Inserted")
            }
            else {
                print("Error \(strQueary)")
            }
        }
    }
}
