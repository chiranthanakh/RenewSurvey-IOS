//
//  LanguageSelectionVM.swift
//  ReNew
//
//  Created by Shiyani on 12/12/23.
//

import UIKit

class LanguageSelectionVM: NSObject {

    var viewController: LanguageSelectionVC?
    var arrLanguage = [ModelLanguage]()
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "LanguageSelectionTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
        self.getLanguageList()
    }
    
    func getLanguageList() {
        self.arrLanguage = DataManager.getLanguageList()
        self.viewController?.tblView.reloadData()
    }
    
}
