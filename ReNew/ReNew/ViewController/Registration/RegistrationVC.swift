//
//  RegistrationVC.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class RegistrationVC: UIViewController {

    @IBOutlet var vwFullName: InputTextFeildView!
    @IBOutlet var vwUserName: InputTextFeildView!
    @IBOutlet var vwEmail: InputTextFeildView!
    @IBOutlet var vwPassword: InputTextFeildView!
    @IBOutlet var vwConfirmPassword: InputTextFeildView!
    @IBOutlet var vwAddress: InputTextFeildView!
    @IBOutlet var vwState: InputTextFeildView!
    @IBOutlet var vwDistrict: InputTextFeildView!
    @IBOutlet var vwTehsil: InputTextFeildView!
    @IBOutlet var vwPanchayat: InputTextFeildView!
    @IBOutlet var vwVillage: InputTextFeildView!
    @IBOutlet var vwPinCode: InputTextFeildView!
    @IBOutlet var vwDOB: InputTextFeildView!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var lblTitile: UILabel!
    @IBOutlet var lblProjectTitle: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var imgUserProfile: UIImageView!
    @IBOutlet var btnTermsCheckBox: UIButton!
    @IBOutlet var lblTerms: UILabel!
    
    var viewModel = RegistrationVM()
    var imagePicker = ImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }
    
    
}

//MARK: - Init Config
extension RegistrationVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.imagePicker.viewController = self
        self.lblTitile.text = "Registration (\(self.viewModel.dicVericifationParam["project_code"] as? String ?? ""))"
        self.lblProjectTitle.text = self.viewModel.dicVericifationParam["title"] as? String ?? ""
        self.lblState.text = self.viewModel.dicVericifationParam["state_name"] as? String ?? ""
        self.vwState.completion = {
            self.viewModel.getStateList { arrState in
                if let arrList = arrState?.compactMap({ ModelListSelection.init(id: $0.mstStateId, name: $0.stateName)}) {
                    let vc = ListSelectionVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.viewModel.arrList = arrList
                    vc.viewModel.strTitle = "Select State"
                    vc.completion = { state in
                        self.vwState.txtInput.text = state.name
                        self.viewModel.selectedState = ModelState(fromDictionary: [:])
                        self.viewModel.selectedState?.mstStateId = state.id
                        self.viewModel.selectedState?.stateName = state.name
                    }
                    self.present(vc, animated: true)
                }
            }
        }
        
        self.vwDistrict.completion = {
            if self.vwState.txtInput.text == "" {
                self.showAlert(with: "Please select state first")
                return
            }
            self.viewModel.getDistrictsList(stateid: self.viewModel.selectedState?.mstStateId ?? "") { arrState in
                if let arrList = arrState?.compactMap({ ModelListSelection.init(id: $0.mstDistrictId, name: $0.districtName)}) {
                    let vc = ListSelectionVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.viewModel.arrList = arrList
                    vc.viewModel.strTitle = "Select District"
                    vc.completion = { district in
                        self.vwDistrict.txtInput.text = district.name
                        self.viewModel.selectedDistrict = ModelDistrict(fromDictionary: [:])
                        self.viewModel.selectedDistrict?.mstDistrictId = district.id
                        self.viewModel.selectedDistrict?.districtName = district.name
                    }
                    self.present(vc, animated: true)
                }
            }
        }
        
        self.vwTehsil.completion = {
            if self.vwDistrict.txtInput.text == "" {
                self.showAlert(with: "Please select district first")
                return
            }
            self.viewModel.getTehsilsList(districtsid: self.viewModel.selectedDistrict?.mstDistrictId ?? "") { arrState in
                if let arrList = arrState?.compactMap({ ModelListSelection.init(id: $0.mstTehsilId, name: $0.tehsilName)}) {
                    let vc = ListSelectionVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.viewModel.arrList = arrList
                    vc.viewModel.strTitle = "Select Tehsil"
                    vc.completion = { tehsil in
                        self.vwTehsil.txtInput.text = tehsil.name
                        self.viewModel.selectedTehsil = ModelTehsil(fromDictionary: [:])
                        self.viewModel.selectedTehsil?.mstTehsilId = tehsil.id
                        self.viewModel.selectedTehsil?.tehsilName = tehsil.name
                    }
                    self.present(vc, animated: true)
                }
            }
        }
        
        self.vwPanchayat.completion = {
            if self.vwTehsil.txtInput.text == "" {
                self.showAlert(with: "Please select tehsil first")
                return
            }
            self.viewModel.getPanchayatsList(tehsilsid: self.viewModel.selectedTehsil?.mstTehsilId ?? "") { arrState in
                if let arrList = arrState?.compactMap({ ModelListSelection.init(id: $0.mstPanchayatId, name: $0.panchayatName)}) {
                    let vc = ListSelectionVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.viewModel.arrList = arrList
                    vc.viewModel.strTitle = "Select Panchayat"
                    vc.completion = { panchayat in
                        self.vwPanchayat.txtInput.text = panchayat.name
                        self.viewModel.selectedPanchayat = ModelPanchayat(fromDictionary: [:])
                        self.viewModel.selectedPanchayat?.mstPanchayatId = panchayat.id
                        self.viewModel.selectedPanchayat?.panchayatName = panchayat.name
                    }
                    self.present(vc, animated: true)
                }
            }
        }
        
        self.vwVillage.completion = {
            if self.vwPanchayat.txtInput.text == "" {
                self.showAlert(with: "Please select panchayat first")
                return
            }
            self.viewModel.getVillagesList(panchayatid: self.viewModel.selectedPanchayat?.mstPanchayatId ?? "") { arrState in
                if let arrList = arrState?.compactMap({ ModelListSelection.init(id: $0.mstVillagesId, name: $0.villageName)}) {
                    let vc = ListSelectionVC()
                    vc.modalPresentationStyle = .overFullScreen
                    vc.viewModel.arrList = arrList
                    vc.viewModel.strTitle = "Select Village"
                    vc.completion = { panchayat in
                        self.vwVillage.txtInput.text = panchayat.name
                        self.viewModel.selectedVillage = ModelVillage(fromDictionary: [:])
                        self.viewModel.selectedVillage?.mstVillagesId = panchayat.id
                        self.viewModel.selectedVillage?.villageName = panchayat.name
                    }
                    self.present(vc, animated: true)
                }
            }
        }
        
        self.vwDOB.completion = {
            let datePicker = DatePickerDialog()
            datePicker.show("Select Date of borth Date",
                            doneButtonTitle: "Done",
                            cancelButtonTitle: "Cancel",
                            defaultDate: Date(),
                            minimumDate: nil,
                            maximumDate: Date(),
                            datePickerMode: .date) { (date) in
                if let dt = date {
                    self.vwDOB.txtInput.text = dt.getFormattedString(format: "dd-MM-yyyy")
                }
            }
        }
        
        self.lblTerms.termsAttributedTextLable(firstString: "I accept ", secondString: "terms & conditions")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapTermLable))
        self.lblTerms.isUserInteractionEnabled = true
        self.lblTerms.addGestureRecognizer(tap)
        self.viewModel.perfixDataBind()
        
    }
    
    @objc func tapTermLable(sender:UITapGestureRecognizer) {
        if let text = self.lblTerms.text,let lbl = self.lblTerms {
            let termsRange = (text as NSString).range(of: "terms & conditions")
            
            if sender.didTapAttributedTextInLabel(label: lbl, inRange: termsRange) {
                print("Terms of use")
                self.present(TermsConditionVC(), animated: true, completion: nil)
            }
            
        }
    }
}

//MARK: - UiButton Action
extension RegistrationVC {
    
    @IBAction func btnMale(_ sender: UIButton) {
        self.btnMale.setImage(UIImage(named: "ic_RadioSelected"), for: .normal)
        self.btnFemale.setImage(UIImage(named: "ic_RadioUnSelected"), for: .normal)
        self.viewModel.strGender = "MALE"
    }
    
    @IBAction func btnFemale(_ sender: UIButton) {
        self.btnFemale.setImage(UIImage(named: "ic_RadioSelected"), for: .normal)
        self.btnMale.setImage(UIImage(named: "ic_RadioUnSelected"), for: .normal)
        self.viewModel.strGender = "FEMALE"
    }
    
    @IBAction func btnProfilePhotoSelect(_ sender: UIButton) {
        self.imagePicker.pickImage(self, "Choose an image source") { image in
            self.imgUserProfile.image = image
        }
    }
    
    @IBAction func btnAcceptTerms(_ sender: UIButton) {
        if sender.tag == 0 {
            self.btnTermsCheckBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            sender.tag = 1
        }
        else {
            self.btnTermsCheckBox.setImage(UIImage(systemName: "square"), for: .normal)
            sender.tag = 0
        }
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        if let msg = self.viewModel.validation() {
            self.showAlert(with: msg)
            return
        }
        self.viewModel.regisetrApiCall()
    }
}

