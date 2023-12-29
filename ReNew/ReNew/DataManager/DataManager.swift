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
        let query = "Select DISTINCT title,p.* from tbl_projects as p  inner join mst_form_language as l on p.tbl_projects_id=l.module_id where l.module='tbl_projects' and mst_language_id=\(kAppDelegate.selectedLanguageID) order by tbl_projects_id"
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
        let query = "SELECT DISTINCT ap.tbl_projects_id,mfl1.title AS project_name, ap.tbl_forms_id, mfl.title as form_name, tpp.tbl_project_phase_id,tpp.phase,tpp.version FROM tbl_users_assigned_projects ap inner JOIN tbl_projects tp ON tp.tbl_projects_id = ap.tbl_projects_id inner JOIN tbl_project_phase tpp ON tpp.tbl_projects_id = ap.tbl_projects_id AND tpp.tbl_forms_id = ap.tbl_forms_id AND tpp.is_released = 'Y' inner JOIN tbl_forms tf ON tf.tbl_forms_id = ap.tbl_forms_id inner JOIN mst_form_language mfl ON mfl.module = 'tbl_forms' AND mfl.module_id = tf.tbl_forms_id AND mfl.is_active = 1 AND mfl.is_delete = 0 AND mfl.mst_language_id = '\(languageId)' inner JOIN mst_form_language mfl1 ON mfl1.module = 'tbl_projects' AND mfl1.module_id = tp.tbl_projects_id AND mfl1.is_active = 1 AND mfl1.is_delete = 0 AND mfl1.mst_language_id = '\(languageId)' WHERE ap.tbl_users_id = '\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")' AND ap.tbl_projects_id = '\(kAppDelegate.selectedProjectID)'"
        var mainarr = [ModelUserRole]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelUserRole(fromDictionary: [:])
                    temp.tblProjectsId  = Int(sqlite3_column_int(stmt, 0))
                    temp.title  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.tblFormsId = Int(sqlite3_column_int(stmt, 2))
                    temp.formName = String(cString: sqlite3_column_text(stmt, 3))
                    temp.tblProjectPhaseId = Int(sqlite3_column_int(stmt, 4))
                    temp.phase = Int(sqlite3_column_int(stmt, 5))
                    temp.version = Int(sqlite3_column_int(stmt, 6))
                    
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    /*static func getUserRoleList(languageId: String) -> [ModelUserRole] {
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
    }*/
    
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
        let query = "SELECT DISTINCT q.mst_question_group_id, q.tbl_form_questions_id, title, question_type, allowed_file_type, min_length, max_length, p.tbl_project_phase_id, p.version, is_mandatory from tbl_project_phase_question as p inner join  tbl_form_questions as q  on q.tbl_form_questions_id = p.tbl_form_questions_id inner join mst_form_language as l on l.module_id = q.tbl_form_questions_id and l.module='tbl_form_questions'  where l.mst_language_id='\(kAppDelegate.selectedLanguageID)' and q.mst_question_group_id= '\(grpId)' and p.tbl_forms_id= '\(kAppDelegate.selectedFormID)' order by q.order_by"
        
        //"SELECT tbl_form_questions_id, title, question_type, allowed_file_type, min_length, max_length FROM tbl_form_questions as q INNER JOIN mst_form_language as I ON q.tbl_form_questions_id = I.module_id AND I.module = 'tbl_form_questions' WHERE I.mst_language_id = '\(kAppDelegate.selectedLanguageID)' AND q.mst_question_group_id = '\(grpId)'  ORDER BY q.order_by"
        var mainarr = [ModelQuestion]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelQuestion(fromDictionary: [:])
                    temp.mstQuestionGroupId  = Int(sqlite3_column_int(stmt, 0))
                    temp.tblFormQuestionsId  = Int(sqlite3_column_int(stmt, 1))
                    temp.title  = String(cString: sqlite3_column_text(stmt,2))
                    temp.questionType  = String(cString: sqlite3_column_text(stmt,3))
                    temp.allowFileType  = String(cString: sqlite3_column_text(stmt,4))
                    temp.minLength  = Int(sqlite3_column_int(stmt, 5))
                    temp.maxLength  = Int(sqlite3_column_int(stmt, 6))
                    temp.tblProjectPhaseId  = Int(sqlite3_column_int(stmt, 7))
                    temp.version  = Int(sqlite3_column_int(stmt, 8))
                    temp.ismandatory  = String(cString: sqlite3_column_text(stmt,9))
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
                    temp.hindi  = String(cString: sqlite3_column_text(stmt,2))
                    temp.marathi  = String(cString: sqlite3_column_text(stmt,3))
                    temp.type  = String(cString: sqlite3_column_text(stmt,4))
                    temp.option  = String(cString: sqlite3_column_text(stmt,5))
                    temp.remark  = String(cString: sqlite3_column_text(stmt,6))
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
    
    static func getStateList() -> [ModelState] {
        let query = "SELECT mst_state_id, state_name from mst_state"
        var mainarr = [ModelState]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelState(fromDictionary: [:])
                    temp.mstStateId  = String(Int(sqlite3_column_int(stmt, 0)))
                    temp.stateName  = String(cString: sqlite3_column_text(stmt, 1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getDistrictList(stateID: String) -> [ModelDistrict] {
        let query = "SELECT mst_district_id, district_name from mst_district WHERE mst_state_id = '\(stateID)'"
        var mainarr = [ModelDistrict]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelDistrict(fromDictionary: [:])
                    temp.mstDistrictId  = String(Int(sqlite3_column_int(stmt, 0)))
                    temp.districtName  = String(cString: sqlite3_column_text(stmt, 1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getTehsilList(stateID: String, districtID: String) -> [ModelTehsil] {
        let query = "SELECT mst_tehsil_id, tehsil_name from mst_tehsil WHERE mst_state_id = '\(stateID)' AND mst_district_id = '\(districtID)'"
        var mainarr = [ModelTehsil]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelTehsil(fromDictionary: [:])
                    temp.mstTehsilId  = String(Int(sqlite3_column_int(stmt, 0)))
                    temp.tehsilName  = String(cString: sqlite3_column_text(stmt, 1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getPanchayatList(stateID: String, districtID: String, tehsilId: String) -> [ModelPanchayat] {
        let query = "SELECT mst_panchayat_id, panchayat_name  from mst_panchayat  WHERE mst_state_id = '\(stateID)' AND mst_district_id = '\(districtID)' AND mst_tehsil_id = '\(tehsilId)'"
        var mainarr = [ModelPanchayat]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelPanchayat(fromDictionary: [:])
                    temp.mstPanchayatId  = String(Int(sqlite3_column_int(stmt, 0)))
                    temp.panchayatName  = String(cString: sqlite3_column_text(stmt, 1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getVillageList(stateID: String, districtID: String, tehsilId: String, panchayatId: String) -> [ModelVillage] {
        let query = "SELECT mst_village_id, village_name from mst_village WHERE mst_state_id = '\(stateID)' AND mst_district_id = '\(districtID)' AND mst_tehsil_id = '\(tehsilId)' AND mst_panchayat_id = '\(panchayatId)'"
        var mainarr = [ModelVillage]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelVillage(fromDictionary: [:])
                    temp.mstVillagesId  = String(Int(sqlite3_column_int(stmt, 0)))
                    temp.villageName  = String(cString: sqlite3_column_text(stmt, 1))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getVillageDetails(villageName: String, panchayatId: String) -> ModelVillage? {
        let query = "SELECT * from mst_village WHERE village_name = '\(villageName)' AND mst_panchayat_id = '\(panchayatId)'"
        var mainarr : ModelVillage?
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelVillage(fromDictionary: [:])
                    temp.mstVillagesId  = String(Int(sqlite3_column_int(stmt, 0)))
                    temp.villageName  = String(cString: sqlite3_column_text(stmt, 1))
                    mainarr = temp
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return mainarr
    }
    
    static func getAsyncFromList() -> [ModelAsyncForm] {
        let query = "SELECT * FROM tbl_FilledForms WHERE tbl_users_id = '\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")' AND tbl_projects_id='\(kAppDelegate.selectedProjectID)' AND mst_language_id='\(kAppDelegate.selectedLanguageID)' AND tbl_forms_id='\(kAppDelegate.selectedFormID)' and status = '0'"
        var mainarr = [ModelAsyncForm]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelAsyncForm(fromDictionary: [:])
                    temp.id  = Int(sqlite3_column_int(stmt, 0))
                    temp.jsonValues  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.status  = Int(sqlite3_column_int(stmt, 2))
                    temp.tblUsersId  = Int(sqlite3_column_int(stmt, 3))
                    temp.tblProjectsId  = Int(sqlite3_column_int(stmt, 4))
                    temp.parentSurveyId  = Int(sqlite3_column_int(stmt, 5))
                    temp.mstLanguageId  = Int(sqlite3_column_int(stmt, 6))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 7))
                    temp.appUniqueCode  = String(cString: sqlite3_column_text(stmt, 8))
                    temp.phase  = Int(sqlite3_column_int(stmt, 9))
                    temp.version  = Int(sqlite3_column_int(stmt, 10))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getAllAsyncFromList() -> [ModelAsyncForm] {
        let query = "SELECT * FROM tbl_FilledForms WHERE status = '0'"
        var mainarr = [ModelAsyncForm]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelAsyncForm(fromDictionary: [:])
                    temp.id  = Int(sqlite3_column_int(stmt, 0))
                    temp.jsonValues  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.status  = Int(sqlite3_column_int(stmt, 2))
                    temp.tblUsersId  = Int(sqlite3_column_int(stmt, 3))
                    temp.tblProjectsId  = Int(sqlite3_column_int(stmt, 4))
                    temp.parentSurveyId  = Int(sqlite3_column_int(stmt, 5))
                    temp.mstLanguageId  = Int(sqlite3_column_int(stmt, 6))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 7))
                    temp.appUniqueCode  = String(cString: sqlite3_column_text(stmt, 8))
                    temp.phase  = Int(sqlite3_column_int(stmt, 9))
                    temp.version  = Int(sqlite3_column_int(stmt, 10))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getDraftFromList() -> [ModelAsyncForm] {
        let query = "SELECT * FROM tbl_FilledForms WHERE tbl_users_id = '\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")' AND tbl_projects_id='\(kAppDelegate.selectedProjectID)' AND mst_language_id='\(kAppDelegate.selectedLanguageID)' AND tbl_forms_id='\(kAppDelegate.selectedFormID)' and status = '2'"
        var mainarr = [ModelAsyncForm]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelAsyncForm(fromDictionary: [:])
                    temp.id  = Int(sqlite3_column_int(stmt, 0))
                    temp.jsonValues  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.status  = Int(sqlite3_column_int(stmt, 2))
                    temp.tblUsersId  = Int(sqlite3_column_int(stmt, 3))
                    temp.tblProjectsId  = Int(sqlite3_column_int(stmt, 4))
                    temp.parentSurveyId  = Int(sqlite3_column_int(stmt, 5))
                    temp.mstLanguageId  = Int(sqlite3_column_int(stmt, 6))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 7))
                    temp.appUniqueCode  = String(cString: sqlite3_column_text(stmt, 8))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getAllDraftFromList() -> [ModelAsyncForm] {
        let query = "SELECT * FROM tbl_FilledForms WHERE status = '2'"
        var mainarr = [ModelAsyncForm]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelAsyncForm(fromDictionary: [:])
                    temp.id  = Int(sqlite3_column_int(stmt, 0))
                    temp.jsonValues  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.status  = Int(sqlite3_column_int(stmt, 2))
                    temp.tblUsersId  = Int(sqlite3_column_int(stmt, 3))
                    temp.tblProjectsId  = Int(sqlite3_column_int(stmt, 4))
                    temp.parentSurveyId  = Int(sqlite3_column_int(stmt, 5))
                    temp.mstLanguageId  = Int(sqlite3_column_int(stmt, 6))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 7))
                    temp.appUniqueCode  = String(cString: sqlite3_column_text(stmt, 8))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getAllFromList() -> [ModelAsyncForm] {
        let query = "SELECT * FROM tbl_FilledForms WHERE tbl_users_id = '\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")' AND tbl_projects_id='\(kAppDelegate.selectedProjectID)' AND mst_language_id='\(kAppDelegate.selectedLanguageID)' AND tbl_forms_id='\(kAppDelegate.selectedFormID)'"
        var mainarr = [ModelAsyncForm]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelAsyncForm(fromDictionary: [:])
                    temp.id  = Int(sqlite3_column_int(stmt, 0))
                    temp.jsonValues  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.status  = Int(sqlite3_column_int(stmt, 2))
                    temp.tblUsersId  = Int(sqlite3_column_int(stmt, 3))
                    temp.tblProjectsId  = Int(sqlite3_column_int(stmt, 4))
                    temp.parentSurveyId  = Int(sqlite3_column_int(stmt, 5))
                    temp.mstLanguageId  = Int(sqlite3_column_int(stmt, 6))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 7))
                    temp.appUniqueCode  = String(cString: sqlite3_column_text(stmt, 8))
                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getAssignedSurveyList() -> [ModelAssignedSurvey] {
        let query = "SELECT tbl_assigned_survey.* from tbl_assigned_survey JOIN tbl_FilledForms On tbl_assigned_survey.parent_survey_id != tbl_FilledForms.parent_survey_id"
        //"SELECT * FROM tbl_assigned_survey"
        var mainarr = [ModelAssignedSurvey]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelAssignedSurvey(fromDictionary: [:])
                    temp.tblProjectSurveyCommonDataId  = String(cString: sqlite3_column_text(stmt, 0))
                    temp.tblProjectsId  = String(cString: sqlite3_column_text(stmt, 1))
                    temp.appUniqueCode  = String(cString: sqlite3_column_text(stmt, 2))
                    temp.banficaryName  = String(cString: sqlite3_column_text(stmt, 3))
                    temp.mstStateId  = String(cString: sqlite3_column_text(stmt, 4))
                    temp.mstDistrictId  = String(cString: sqlite3_column_text(stmt, 5))
                    temp.mstTehsilId  = String(cString: sqlite3_column_text(stmt, 6))
                    temp.mstPanchayatId  = String(cString: sqlite3_column_text(stmt, 7))
                    temp.mstVillageId  = String(cString: sqlite3_column_text(stmt, 8))
                    temp.gender  = String(cString: sqlite3_column_text(stmt, 9))
                    temp.mobileNumber  = String(cString: sqlite3_column_text(stmt, 10))
                    temp.aadharCard  = String(cString: sqlite3_column_text(stmt, 11))
                    temp.familySize  = String(cString: sqlite3_column_text(stmt, 12))
                    temp.isLpgUsing  = String(cString: sqlite3_column_text(stmt, 13))
                    temp.noOfCylinderPerYear  = String(cString: sqlite3_column_text(stmt, 14))
                    temp.isCowDung  = String(cString: sqlite3_column_text(stmt, 15))
                    temp.noOfCowDungPerDay  = String(cString: sqlite3_column_text(stmt, 16))
                    temp.woodUsePerDayInKg  = String(cString: sqlite3_column_text(stmt, 17))
                    temp.houseType  = String(cString: sqlite3_column_text(stmt, 18))
                    temp.electricityConnectionAvailable  = String(cString: sqlite3_column_text(stmt, 19))
                    temp.annualFamilyIncome  = String(cString: sqlite3_column_text(stmt, 20))
                    temp.willingToContributeCleanCooking  = String(cString: sqlite3_column_text(stmt, 21))
                    temp.noOfCattlesOwn  = String(cString: sqlite3_column_text(stmt, 22))
                    temp.systemApproval  = String(cString: sqlite3_column_text(stmt, 23))
                    temp.reason  = String(cString: sqlite3_column_text(stmt, 24))
                    temp.nextFormId  = String(cString: sqlite3_column_text(stmt, 25))
                    temp.parentSurveyId  = String(cString: sqlite3_column_text(stmt, 26))

                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func deleteDraftData() {
        let query = "DELETE FROM tbl_FilledForms WHERE status = '2'"
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("Deleted")
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
    }

    static func getStataName(stateId: String) -> String {
        let query = "SELECT DISTINCT state_name from mst_state WHERE mst_state_id = '\(stateId)'"
        var strResult = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    strResult  = String(cString: sqlite3_column_text(stmt, 0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return strResult
    }
    
    static func getDistrictName(districtId: String) -> String {
        let query = "SELECT DISTINCT district_name from mst_district WHERE mst_district_id = '\(districtId)'"
        var strResult = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    strResult  = String(cString: sqlite3_column_text(stmt, 0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return strResult
    }
    
    static func getTehsilName(tehsilId: String) -> String {
        let query = "SELECT DISTINCT tehsil_name from mst_tehsil WHERE mst_tehsil_id = '\(tehsilId)'"
        var strResult = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    strResult  = String(cString: sqlite3_column_text(stmt, 0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return strResult
    }
    
    static func getPanchayatName(panchayatId: String) -> String {
        let query = "SELECT DISTINCT panchayat_name from mst_panchayat WHERE mst_panchayat_id = '\(panchayatId)'"
        var strResult = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    strResult  = String(cString: sqlite3_column_text(stmt, 0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return strResult
    }
    
    static func getVillageName(villageId: String) -> String {
        let query = "SELECT DISTINCT village_name from mst_village WHERE mst_village_id = '\(villageId)'"
        var strResult = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    strResult  = String(cString: sqlite3_column_text(stmt, 0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return strResult
    }
    
    static func getTestDetail(formId: Int, languageId: Int) -> ModelTest? {
        let query = "SELECT mfl.title,tt.* from tbl_tests as tt LEFT JOIN mst_form_language mfl ON mfl.module = 'tbl_tests' AND mfl.module_id = tt.tbl_tests_id WHERE tt.tbl_forms_id = '\(formId)'  AND mst_language_id = '\(languageId)'"
        var mainarr: ModelTest?
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelTest(fromDictionary: [:])
                    temp.title  = String(cString: sqlite3_column_text(stmt, 0))
                    temp.tblTestsId  = Int(sqlite3_column_int(stmt, 1))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 2))
                    temp.createdBy  = Int(sqlite3_column_int(stmt, 3))
                    temp.testCode  = String(cString: sqlite3_column_text(stmt, 4))
                    temp.passingMarks  = String(cString: sqlite3_column_text(stmt, 5))
                    temp.createDate  = String(cString: sqlite3_column_text(stmt, 6))
                    temp.isActive  = Int(sqlite3_column_int(stmt, 7))
                    temp.isDelete  = Int(sqlite3_column_int(stmt, 8))
                    temp.lastUpdate  = String(cString: sqlite3_column_text(stmt, 9))
                    
                    mainarr = temp
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return mainarr
    }
    
    static func getTestQuestionOptionList(languageId: Int, questionId: Int) -> [ModelTestQuestionOption] {
        let query = "SELECT l.title, q.* from tbl_test_questions_option as q inner join mst_form_language as l on q.tbl_test_questions_option_id=l.module_id where l.module='tbl_test_questions_option' and tbl_test_questions_id= \(questionId) and l.mst_language_id = \(languageId)"
        var mainarr = [ModelTestQuestionOption]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelTestQuestionOption(fromDictionary: [:])
                    temp.title  = String(cString: sqlite3_column_text(stmt, 0))
                    temp.tblTestQuestionsOptionId  = Int(sqlite3_column_int(stmt, 1))
                    temp.tblTestQuestionsId  = Int(sqlite3_column_int(stmt, 2))
                    temp.createdBy  = Int(sqlite3_column_int(stmt, 3))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 4))
                    temp.tblTestsId  = Int(sqlite3_column_int(stmt, 5))
                    temp.isAnswer  = String(cString: sqlite3_column_text(stmt, 6))
                    temp.createDate  = String(cString: sqlite3_column_text(stmt, 7))
                    temp.isActive  = Int(sqlite3_column_int(stmt, 8))
                    temp.isDelete  = Int(sqlite3_column_int(stmt, 9))
                    temp.lastUpdate  = String(cString: sqlite3_column_text(stmt, 10))

                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getTestQuestionList(languageId: Int, testId: Int) -> [ModelTestQuestion] {
        let query = "SELECT mfl.title, tq.* from tbl_test_questions as tq LEFT JOIN mst_form_language mfl ON mfl.module = 'tbl_test_questions' AND mfl.module_id = tbl_test_questions_id WHERE tbl_tests_id = \(testId) AND tq.is_active AND mst_language_id = \(languageId)"
        var mainarr = [ModelTestQuestion]()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let temp = ModelTestQuestion(fromDictionary: [:])
                    temp.title  = String(cString: sqlite3_column_text(stmt, 0))
                    temp.tblTestQuestionsId  = Int(sqlite3_column_int(stmt, 1))
                    temp.tblTestsId  = Int(sqlite3_column_int(stmt, 2))
                    temp.tblFormsId  = Int(sqlite3_column_int(stmt, 3))
                    temp.createdBy  = Int(sqlite3_column_int(stmt, 4))
                    temp.questionType  = String(cString: sqlite3_column_text(stmt, 5))
                    temp.isMandatory  = String(cString: sqlite3_column_text(stmt, 6))
                    temp.orderBy  = Int(sqlite3_column_int(stmt, 7))
                    temp.isValidationRequired  = String(cString: sqlite3_column_text(stmt, 8))
                    temp.isSpecialCharAllowed  = String(cString: sqlite3_column_text(stmt, 9))
                    temp.minLength  = Int(sqlite3_column_int(stmt, 10))
                    temp.maxLength  = Int(sqlite3_column_int(stmt, 11))
                    temp.format  = String(cString: sqlite3_column_text(stmt, 12))
                    temp.answer  = String(cString: sqlite3_column_text(stmt, 13))
                    temp.createDate  = String(cString: sqlite3_column_text(stmt, 14))
                    temp.isActive  = Int(sqlite3_column_int(stmt, 15))
                    temp.isDelete  = Int(sqlite3_column_int(stmt, 16))
                    temp.lastUpdate  = String(cString: sqlite3_column_text(stmt, 17))

                    mainarr.append(temp)
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        print(mainarr.count)
        return mainarr
    }
    
    static func getTestTutorial(testId: Int) -> String {
        let query = "SELECT tt.tutorial_file from tbl_tutorials as tt WHERE tt.tbl_tutorials_id = \(testId)"
        var mainarr = String()
        var dbop :OpaquePointer? = nil
        if sqlite3_open(DataManager.databasePath(), &dbop) == SQLITE_OK {
            var stmt : OpaquePointer? = nil
            if sqlite3_prepare_v2(dbop, query, -1, &stmt, nil) == SQLITE_OK{
                while sqlite3_step(stmt) == SQLITE_ROW {
                    mainarr = String(cString: sqlite3_column_text(stmt, 0))
                }
                sqlite3_finalize(stmt)
            }
            sqlite3_close(dbop)
        }
        return mainarr
    }
    
    static func deleteDatabase() {
        do {
            _ =  try FileManager.default.removeItem(at: URL(fileURLWithPath: DataManager.databasePath()))
        } catch  {
            
        }
    }
    
    static func syncWithServer(completionHandler: @escaping () -> Void) {
        let formList = self.getAllAsyncFromList()
        
        if formList.count == 0 {
            kAppDelegate.window?.topMostController()?.showAlert(with: "No any pending form to sync.")
            return
        }
        
        var arrFileDic = [[String:Any]]()
        var arrFiles = [Any]()
        
        formList.forEach { form in
            let questionJson = form.jsonValues.toFragmentsAllowedSingleJson()
            if let questionAnswer = questionJson["question_answer"] as? [[String:Any]] {
                questionAnswer.forEach { question in
                    if let questionType = question["question_type"] as? String {
                        if questionType == "CAPTURE",let answer = question["strImageBase64"] as? String, let img = answer.base64ToImage() {
                            arrFiles.append(img)
                            arrFileDic.append(["tbl_users_id": form.tblUsersId,
                                               "tbl_forms_id": form.tblFormsId,
                                               "tbl_projects_id": form.tblProjectsId,
                                               "version": question["version"] as? Int ?? 0,
                                               "phase": form.phase,
                                               "app_unique_code": form.appUniqueCode,
                                               "tbl_form_questions_id": question["tbl_form_questions_id"] as? Int ?? 0,
                                               "file_name": question["answer"] as? String ?? ""])
                        }
                        else if questionType == "FILE", let answer = question["answer"] as? String {
                            if let url =  getFileFromDocuments(fileName: answer){
                                arrFiles.append(url)
                            }
                            
                            let fileName = "\(ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? "")_\(form.tblProjectsId)_\(form.tblFormsId)_\(form.tblProjectPhaseId)_\(URL(fileURLWithPath: answer).lastPathComponent)"
                            arrFileDic.append(["tbl_users_id": form.tblUsersId,
                                               "tbl_forms_id": form.tblFormsId,
                                               "tbl_projects_id": form.tblProjectsId,
                                               "version": question["version"] as? Int ?? 0,
                                               "phase": form.phase,
                                               "app_unique_code": form.appUniqueCode,
                                               "tbl_form_questions_id": question["tbl_form_questions_id"] as? Int ?? 0,
                                               "file_name": fileName])
                        }
                    }
                }
            }
        }
        
        if arrFiles.count == 0 {
            self.uploadFormToServer(formList: formList) {
                completionHandler()
            }
        }
        else {
            let param = ["post_data": arrFileDic]
            APIManager.sharedInstance.requestUploadMedia(endpointurl: AppConstant.API.kSyncMedia, parameters: param as NSDictionary, arrFiles: arrFiles, isShowLoader: true) { error, dict in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let responsedic = dict {
                    if (responsedic["success"] as? String ?? "") == "1" {
                        self.uploadFormToServer(formList: formList) {
                            self.updatedDbToFormUpload(formList: formList)
                            completionHandler()
                        }
                    }
                    else {
                        kAppDelegate.window?.topMostController()?.showAlert(with: responsedic["message"] as? String ?? "")
                    }
                }
            }
        }
    }
    
    static func uploadFormToServer(formList: [ModelAsyncForm], completionHandler: @escaping () -> Void) {
        
        var dic = [[String:Any]]()
        
        formList.forEach { form in
            var formJson = form.jsonValues.toFragmentsAllowedSingleJson()
            for item2 in 0..<(formJson["question_answer"] as! [[String:Any]]).count {
                let x = (formJson["question_answer"] as! NSArray).mutableCopy() as? NSMutableArray
                let y = (x?.object(at: item2) as? NSDictionary)?.mutableCopy() as? NSMutableDictionary
                y?["strImageBase64"] = ""
                y?["question_type"] = ""
                y?["title"] = ""
                y?["allowed_file_type"] = ""
                y?["question_Option"] = ""
                y?["mst_question_group_id"] = ""
                y?["version"] = ""
                y?["tbl_project_phase_id"] = ""
                y?["version"] = ""
                y?["minLength"] = ""
                y?["maxLength"] = ""
                y?["is_mandatory"] = ""
                x?.replaceObject(at: item2, with: y)
                formJson["question_answer"] = x
            }
            dic.append(formJson)
        }
        
        
        print(dic)
                
        APIManager.sharedInstance.requestAsyncDataUploadToServer(endpointurl: AppConstant.API.kSyncSurvey, parameters: dic, isShowLoader: true) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    print(responsedic)
                    completionHandler()
                }
                else {
                    kAppDelegate.window?.topMostController()?.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
    static func updatedDbToFormUpload(formList: [ModelAsyncForm]) {
        formList.forEach { asyncForm in
            let query = "UPDATE tbl_FilledForms SET status = '1' WHERE id = '\(asyncForm.id)'"
            if DataManager.DML(query: query) == true {
                print("Inserted")
            }
            else {
                print("Error \(query)")
            }
        }
        kAppDelegate.window?.topMostController()?.showAlert(with: "Form sync successfully")
        //self.getAsyncFormList()
    }
}
