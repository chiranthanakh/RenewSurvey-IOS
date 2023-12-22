//
//  ProjectSelectionVM.swift
//  ReNew
//
//  Created by Shiyani on 13/12/23.
//

import UIKit

class ProjectSelectionVM {
    
    var viewController: ProjectSelectionVC?
    var arrLanguage = [ModelProject]()
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "ProjectSelectionTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
        self.getLanguageList()
    }
    
    func getLanguageList() {
        self.arrLanguage = DataManager.getProjectList()
        self.viewController?.tblView.reloadData()
    }
    
}
