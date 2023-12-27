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
    var selectedformType : FormType = .Distribution
    
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "DraftListTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
    }
    
    func getAssignedList() {
        self.arrAssignedList = DataManager.getAssignedSurveyList().filter({$0.nextFormId == "\(kAppDelegate.selectedFormID)"})
        print(self.arrAssignedList)
        self.viewController?.tblView.reloadData()
    }
    
}

enum FormType {
    case Distribution
    case Feedback
}
