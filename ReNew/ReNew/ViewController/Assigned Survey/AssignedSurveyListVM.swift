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
    var arrAllAssignedList = [ModelAssignedSurvey]()
    var selectedformType : FormType = .Distribution
    
    var selectedState: ModelState?
    var selectedDistrict: ModelDistrict?
    var selectedTehsil: ModelTehsil?
    var selectedPanchayat: ModelPanchayat?
    var selectedVillage: ModelVillage?
    var delegate: FilterDelegate?
    
    func registerController() {
        self.viewController?.tblView.registerCell(withNib: "DraftListTCell")
        self.viewController?.tblView.delegate = self.viewController
        self.viewController?.tblView.dataSource = self.viewController
    }
    
    func getAssignedList() {
        self.arrAllAssignedList = DataManager.getAssignedSurveyList().filter({$0.nextFormId == "\(kAppDelegate.selectedFormID)"})
        print(self.arrAssignedList)
        self.searchAssigne(strSearch: "")
    }
    
    func searchAssigne(strSearch: String) {
       if strSearch == ""  {
           self.arrAssignedList = self.arrAllAssignedList
       }
       else {
           self.arrAssignedList = self.arrAllAssignedList.filter{$0.banficaryName.localizedCaseInsensitiveContains(strSearch) || $0.stateName.localizedCaseInsensitiveContains(strSearch) || $0.villageName.localizedCaseInsensitiveContains(strSearch) || $0.districtName.localizedCaseInsensitiveContains(strSearch) || $0.aadharCard.localizedCaseInsensitiveContains(strSearch)}
       }
       
       self.viewController?.tblView.reloadData()
   }
    
    func filterData() {
        var arrTemp = DataManager.getAssignedSurveyList().filter({$0.nextFormId == "\(kAppDelegate.selectedFormID)"})
        if let village = self.selectedVillage {
            arrTemp = arrTemp.filter({$0.mstVillageId == village.mstVillagesId})
        }
        else if let panchayat = self.selectedPanchayat {
            arrTemp = arrTemp.filter({$0.mstPanchayatId == panchayat.mstPanchayatId})
        }
        else if let tehsil = self.selectedTehsil {
            arrTemp = arrTemp.filter({$0.mstTehsilId == tehsil.mstTehsilId})
        }
        else if let district = self.selectedDistrict{
            arrTemp = arrTemp.filter({$0.mstDistrictId == district.mstDistrictId})
        }
        else if let state = self.selectedState{
            arrTemp = arrTemp.filter({$0.mstStateId == state.mstStateId})
        }
        self.arrAllAssignedList = arrTemp
        self.searchAssigne(strSearch: self.viewController?.vwSearchBar.text ?? "")
    }
}

enum FormType {
    case Distribution
    case Feedback
}
