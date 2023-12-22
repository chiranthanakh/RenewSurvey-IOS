//
//  UserRoleSelectionVM.swift
//  ReNew
//
//  Created by Shiyani on 13/12/23.
//

import UIKit

class UserRoleSelectionVM {
    
    var viewController: UserRoleSelectionVC?
    var arrLanguage = [ModelUserRole]()
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "ProjectSelectionTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
        self.getLanguageList()
    }
    
    func getLanguageList() {
        self.arrLanguage = DataManager.getUserRoleList(languageId: "1")
        self.viewController?.tblView.reloadData()
    }
    
}
