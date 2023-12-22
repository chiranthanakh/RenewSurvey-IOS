//
//  ListSelectionVM.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class ListSelectionVM: NSObject {

    var viewController: ListSelectionVC?
    var arrList = [ModelListSelection]()
    var arrFilterList = [ModelListSelection]()
    var arrSelectedList = [ModelListSelection]()
    var strTitle = String()
    
    func dataBind(strSearch: String) {
        if strSearch == "" {
            self.arrFilterList = self.arrList
        }
        else {
            self.arrFilterList = self.arrList.filter({$0.name.localizedCaseInsensitiveContains(strSearch)})
        }
        self.viewController?.tblView.reloadData()
    }
}

class ModelListSelection {
    
    var id = String()
    var name = String()
    var isSelected = false
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
