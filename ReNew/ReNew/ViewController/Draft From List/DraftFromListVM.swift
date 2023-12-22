//
//  DraftFromListVM.swift
//  ReNew
//
//  Created by Shiyani on 22/12/23.
//

import UIKit

class DraftFromListVM: NSObject {

    var viewController: DraftFromListVC?
    var arrList = [ModelFormDraft]()
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "DraftListTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
        
    }
    
    func getDraftFormList() {
        self.arrList.removeAll()
        let arrDraft = DataManager.getDraftFromList()
        arrDraft.forEach { form in
            self.arrList.append(ModelFormDraft.init(fromDictionary: form.jsonValues.toFragmentsAllowedSingleJson()))
        }
        self.viewController?.tblView.reloadData()
    }
    
}
