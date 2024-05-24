//
//  FilterAssigneeVC.swift
//  ReNew
//
//  Created by Shiyani on 01/04/24.
//

import UIKit

protocol FilterDelegate {
    func filterDidApplied(state: ModelState?, district: ModelDistrict?, tehsil: ModelTehsil?, panchayat: ModelPanchayat?, village: ModelVillage?)
}

class FilterAssigneeVC: UIViewController {

    @IBOutlet var vwState: InputTextFeildView!
    @IBOutlet var vwDistict: InputTextFeildView!
    @IBOutlet var vwTehsil: InputTextFeildView!
    @IBOutlet var vwPanchyat: InputTextFeildView!
    @IBOutlet var vwVillage: InputTextFeildView!

    var selectedState: ModelState?
    var selectedDistrict: ModelDistrict?
    var selectedTehsil: ModelTehsil?
    var selectedPanchayat: ModelPanchayat?
    var selectedVillage: ModelVillage?
    var delegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }

    @IBAction func btnReset(_ sender: UIButton) {
        self.selectedDistrict = nil
        self.selectedTehsil = nil
        self.selectedPanchayat = nil
        self.selectedVillage = nil
        self.selectedState = nil
        self.delegate?.filterDidApplied(state: self.selectedState, district: self.selectedDistrict, tehsil: self.selectedTehsil, panchayat: self.selectedPanchayat, village: self.selectedVillage)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        self.delegate?.filterDidApplied(state: self.selectedState, district: self.selectedDistrict, tehsil: self.selectedTehsil, panchayat: self.selectedPanchayat, village: self.selectedVillage)
        self.dismiss(animated: true)
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

//MARK: - Init Config
extension FilterAssigneeVC {
    
    private func initConfig() {
        self.vwState.txtInput.text = self.selectedState?.stateName ?? ""
        self.vwDistict.txtInput.text = self.selectedDistrict?.districtName ?? ""
        self.vwTehsil.txtInput.text = self.selectedTehsil?.tehsilName ?? ""
        self.vwPanchyat.txtInput.text = self.selectedPanchayat?.panchayatName ?? ""
        self.vwVillage.txtInput.text = self.selectedVillage?.villageName ?? ""
        
        self.vwState.completion = {
            let arrList = DataManager.getStateList().compactMap({ ModelListSelection.init(id: $0.mstStateId, name: $0.stateName)})
            let vc = ListSelectionVC()
            vc.modalPresentationStyle = .overFullScreen
            vc.viewModel.arrList = arrList
            vc.viewModel.strTitle = "Select State"
            vc.completion = { state in
                self.vwState.txtInput.text = state.name
                self.selectedState = ModelState(fromDictionary: [:])
                self.selectedState?.mstStateId = state.id
                self.selectedState?.stateName = state.name
                self.selectedDistrict = nil
                self.selectedTehsil = nil
                self.selectedPanchayat = nil
                self.selectedVillage = nil
                self.vwDistict.txtInput.text = ""
                self.vwTehsil.txtInput.text = ""
                self.vwPanchyat.txtInput.text = ""
                self.vwVillage.txtInput.text = ""
            }
            self.present(vc, animated: true)
        }
        
        self.vwDistict.completion = {
            if self.vwState.txtInput.text == "" {
                self.showAlert(with: "Please select state first.")
            }
            else {
                let arrList = DataManager.getDistrictList(stateID: self.selectedState?.mstStateId ?? "").compactMap({ ModelListSelection.init(id: $0.mstDistrictId, name: $0.districtName)})
                let vc = ListSelectionVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.viewModel.arrList = arrList
                vc.viewModel.strTitle = "Select District"
                vc.completion = { state in
                    self.vwDistict.txtInput.text = state.name
                    self.selectedDistrict = ModelDistrict(fromDictionary: [:])
                    self.selectedDistrict?.mstDistrictId = state.id
                    self.selectedDistrict?.districtName = state.name
                    self.selectedTehsil = nil
                    self.selectedPanchayat = nil
                    self.selectedVillage = nil
                    self.vwTehsil.txtInput.text = ""
                    self.vwPanchyat.txtInput.text = ""
                    self.vwVillage.txtInput.text = ""
                }
                self.present(vc, animated: true)
            }
        }
        
        self.vwTehsil.completion = {
            if self.vwDistict.txtInput.text == "" {
                self.showAlert(with: "Please select district first.")
            }
            else {
                let arrList = DataManager.getTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "").compactMap({ ModelListSelection.init(id: $0.mstTehsilId, name: $0.tehsilName)})
                let vc = ListSelectionVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.viewModel.arrList = arrList
                vc.viewModel.strTitle = "Select Tehsil"
                vc.completion = { state in
                    self.vwTehsil.txtInput.text = state.name
                    self.selectedTehsil = ModelTehsil(fromDictionary: [:])
                    self.selectedTehsil?.mstTehsilId = state.id
                    self.selectedTehsil?.tehsilName = state.name
                    self.selectedPanchayat = nil
                    self.selectedVillage = nil
                    self.vwPanchyat.txtInput.text = ""
                    self.vwVillage.txtInput.text = ""
                }
                self.present(vc, animated: true)
            }
        }
        
        self.vwPanchyat.completion = {
            if self.vwTehsil.txtInput.text == "" {
                self.showAlert(with: "Please select tehsil first.")
            }
            else {
                let arrList = DataManager.getPanchayatList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "").compactMap({ ModelListSelection.init(id: $0.mstPanchayatId, name: $0.panchayatName)})
                let vc = ListSelectionVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.viewModel.arrList = arrList
                vc.viewModel.strTitle = "Select Panchayat"
                vc.completion = { state in
                    self.vwPanchyat.txtInput.text = state.name
                    self.selectedPanchayat = ModelPanchayat(fromDictionary: [:])
                    self.selectedPanchayat?.mstPanchayatId = state.id
                    self.selectedPanchayat?.panchayatName = state.name
                    self.selectedVillage = nil
                    self.vwVillage.txtInput.text = ""
                }
                self.present(vc, animated: true)
            }
        }
        
        self.vwVillage.completion = {
            if self.vwTehsil.txtInput.text == "" {
                self.showAlert(with: "Please select panchayat first.")
            }
            else {
                let arrList = DataManager.getVillageWithTehsilList(stateID: self.selectedState?.mstStateId ?? "", districtID: self.selectedDistrict?.mstDistrictId ?? "", tehsilId: self.selectedTehsil?.mstTehsilId ?? "", panchayatId: self.selectedPanchayat?.mstPanchayatId ?? "").compactMap({ ModelListSelection.init(id: $0.mstVillagesId, name: $0.villageName)})
                let vc = ListSelectionVC()
                vc.modalPresentationStyle = .overFullScreen
                vc.viewModel.arrList = arrList
                vc.viewModel.strTitle = "Select Village"
                vc.completion = { state in
                    self.vwVillage.txtInput.text = state.name
                    self.selectedVillage = ModelVillage(fromDictionary: [:])
                    self.selectedVillage?.mstVillagesId = state.id
                    self.selectedVillage?.villageName = state.name
                }
                self.present(vc, animated: true)
            }
        }
    }
    
}
