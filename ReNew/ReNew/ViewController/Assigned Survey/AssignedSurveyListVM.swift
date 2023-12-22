//
//  AssignedSurveyListVM.swift
//  ReNew
//
//  Created by Shiyani on 22/12/23.
//

import UIKit

class AssignedSurveyListVM {

    var viewController: AssignedSurveyListVC?
    var arrAssignedList = [ModelAssignedSurvey]()
    
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "DraftListTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
    }
    
    func getAssignedList() {
        self.arrAssignedList = DataManager.getAssignedSurveyList()
    }
    
}
