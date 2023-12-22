//
//  DataManager.swift
//  LoveTracker
//
//  Created by Shiyani on 19/08/23.
//

import Foundation
import UIKit
import SQLite3

class DataManager: NSObject {
    
    static func createcopy()  {
        let finalpath = DataManager.databasePath()
        print(finalpath)
        let flm = FileManager()
        if !flm.fileExists(atPath: finalpath) {
            let localpath = Bundle.main.path(forResource: "RenewDatabse", ofType: "db")
            do{
                try flm.copyItem(atPath: localpath!, toPath: finalpath)
            }catch{
            }
        }
    }
    
    static func databasePath() -> String{
        let arr = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = arr[0]
        let finalpath = path.appending("/RenewDatabse.db")
        return finalpath
    }
    
    static func detacDevice() -> Int  {
        let iPhoneVersion = (UIScreen.main.bounds.size.height > 896 ? 1 : 0)
        return iPhoneVersion
    }
    
    static func randomNumberBetween(_ min: Int, maxNumber max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - (min + 1))))
    }
    
    static func DML(query:String) -> Bool {
        var status : Bool = false
        
        var dbop : OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                sqlite3_step(stmt)
                status = true
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return status
    }
    
    static func checkIfTableExist(strTblName: String) -> Bool {
        let query = "SELECT name FROM sqlite_master WHERE type='table' AND name='\(strTblName)'"
        var dbop :OpaquePointer? = nil
        var mainarr = [Any]()

        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    mainarr.append(Int(sqlite3_column_int(stmt, 0)))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return (mainarr.count > 0)
    }
    
    static func getLanguageList() -> [ModelLanguage] {
        let query = "select * from mst_language"
        var mainarr = [ModelLanguage]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelLanguage(fromDictionary: [:])
                    temp.mstLanguageId  = Int(sqlite3_column_int(stmt, 0))
                    temp.title  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.symbol = String(cString: sqlite3_column_text(stmt, 2))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getProjectList() -> [ModelProject] {
        let query = "Select DISTINCT title,p.* from tbl_projects as p  inner join mst_form_language as l on p.tbl_projects_id=l.module_id where l.module='tbl_projects' and mst_language_id=1 order by tbl_projects_id"
        var mainarr = [ModelProject]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelProject(fromDictionary: [:])
                    
                    temp.tblProjectsId  = Int(sqlite3_column_int(stmt, 1))
                    temp.projectCode  = String(cString: sqlite3_column_text(stmt, 3))
                    temp.title  = String(cString: sqlite3_column_text(stmt, 0))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getUserRoleList(languageId: String) -> [ModelUserRole] {
        let query = "SELECT  tbl_forms_id, mst_form_language_id , title FROM mst_form_language INNER JOIN tbl_forms ON mst_form_language.module_id = tbl_forms.tbl_forms_id WHERE mst_form_language.module ='tbl_forms' AND mst_form_language.mst_language_id = '\(languageId)'"
        var mainarr = [ModelUserRole]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelUserRole(fromDictionary: [:])
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 0))
                    temp.mstFormLanguageId  = Int(sqlite3_column_int(stmt, 1))
                    temp.title  = String(cString: sqlite3_column_text(stmt, 2))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getFormGroupList() -> [ModelFormGroup] {
        let query = "SELECT title,mst_question_group.mst_question_group_id FROM tbl_project_phase_question LEFT JOIN mst_question_group  ON mst_question_group.mst_question_group_id = tbl_project_phase_question.mst_question_group_id LEFT JOIN mst_form_language ON mst_form_language.module_id =  mst_question_group.mst_question_group_id AND mst_form_language.module = 'mst_question_group' WHERE mst_form_language.mst_language_id = '\(kAppDelegate.selectedLanguageID)' AND tbl_project_phase_question.tbl_projects_id = '\(kAppDelegate.selectedProjectID)' AND  tbl_project_phase_question.tbl_forms_id = '\(kAppDelegate.selectedFormID)' GROUP BY mst_question_group.mst_question_group_id ORDER By mst_question_group.order_by"
        var mainarr = [ModelFormGroup]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelFormGroup(fromDictionary: [:])
                    temp.title  = String(cString: sqlite3_column_text(stmt,0))
                    temp.mstQuestionGroupId  = Int(sqlite3_column_int(stmt, 1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getQuestionList(grpId: Int) -> [ModelQuestion] {
        let query = "SELECT tbl_form_questions_id, title, question_type, allowed_file_type, min_length, max_length FROM tbl_form_questions as q INNER JOIN mst_form_language as I ON q.tbl_form_questions_id = I.module_id AND I.module = 'tbl_form_questions' WHERE I.mst_language_id = '\(kAppDelegate.selectedLanguageID)' AND q.mst_question_group_id = '\(grpId)'  ORDER BY q.order_by"
        var mainarr = [ModelQuestion]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelQuestion(fromDictionary: [:])
                    temp.tblFormQuestionsId  = Int(sqlite3_column_int(stmt, 0))
                    temp.title  = String(cString: sqlite3_column_text(stmt,1))
                    temp.questionType  = String(cString: sqlite3_column_text(stmt,2))
                    temp.allowFileType  = String(cString: sqlite3_column_text(stmt,3))
                    temp.minLength  = Int(sqlite3_column_int(stmt, 4))
                    temp.maxLength  = Int(sqlite3_column_int(stmt, 5))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getQuestionOptionList(questionId: Int) -> [ModelQuestionOption] {
        let query = "SELECT  tbl_form_questions_option_id,title FROM tbl_form_questions_option as q INNER join mst_form_language as I On q.tbl_form_questions_option_id = I.module_id WHERE I.module='tbl_form_questions_option' AND tbl_form_questions_id = '\(questionId)' AND I.mst_language_id = '\(kAppDelegate.selectedLanguageID)'"
        var mainarr = [ModelQuestionOption]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelQuestionOption(fromDictionary: [:])
                    temp.tblFormQuestionsOptionId  = Int(sqlite3_column_int(stmt, 0))
                    temp.title  = String(cString: sqlite3_column_text(stmt,1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getStaticQuestionList() -> [ModelStaticQuestion] {
        let query = "select * from tbl_static_question"
        var mainarr = [ModelStaticQuestion]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelStaticQuestion(fromDictionary: [:])
                    temp.id  = Int(sqlite3_column_int(stmt, 0))
                    temp.question  = String(cString: sqlite3_column_text(stmt,1))
                    temp.hindi  = String(cString: sqlite3_column_text(stmt,1))
                    temp.marathi  = String(cString: sqlite3_column_text(stmt,1))
                    temp.type  = String(cString: sqlite3_column_text(stmt,1))
                    temp.option  = String(cString: sqlite3_column_text(stmt,1))
                    temp.remark  = String(cString: sqlite3_column_text(stmt,1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getProjectCodeFromProjectId(projectID: Int) -> String {
        let query = "Select DISTINCT project_code from tbl_projects WHERE tbl_projects.tbl_projects_id = '\(kAppDelegate.selectedProjectID)'"
        var result = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    result  = String(cString: sqlite3_column_text(stmt,0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return result
    }
    
    static func getFormTitleFromFormId(formID: Int) -> String {
        let query = "SELECT DISTINCT title FROM mst_form_language INNER JOIN tbl_forms ON mst_form_language.module_id = tbl_forms.tbl_forms_id WHERE mst_form_language.module ='tbl_forms' AND mst_form_language.mst_language_id = '1' and tbl_forms.tbl_forms_id = '\(formID)'"
        var result = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    result  = String(cString: sqlite3_column_text(stmt,0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return result
    }
}
