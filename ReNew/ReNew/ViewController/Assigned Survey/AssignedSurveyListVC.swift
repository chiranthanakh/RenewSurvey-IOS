//
//  AssignedSurveyListVC.swift
//  ReNew
//
//  Created by Shiyani on 22/12/23.
//

import UIKit

class AssignedSurveyListVC: UIViewController {
    
    var viewModel = AssignedSurveyListVM()
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var vwSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initConfig()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getAssignedList()
    }
    
    @IBAction func btnFilter(_ sender: UIButton) {
        let vc = FilterAssigneeVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        vc.selectedDistrict = self.viewModel.selectedDistrict
        vc.selectedTehsil = self.viewModel.selectedTehsil
        vc.selectedPanchayat = self.viewModel.selectedPanchayat
        vc.selectedVillage = self.viewModel.selectedVillage
        vc.selectedState = self.viewModel.selectedState
        self.present(vc, animated: true)
    }
}

//MARK: - Init Config
extension AssignedSurveyListVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.vwSearchBar.delegate = self
        self.viewModel.registerController()
    }
    
}

//MARK: - UITablview Delegate & Datasource Methods
extension AssignedSurveyListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrAssignedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DraftListTCell", for: indexPath) as? DraftListTCell else { return UITableViewCell() }
        
        if self.viewModel.arrAssignedList.indices ~= indexPath.row {
            cell.lblTitle.text = self.viewModel.arrAssignedList[indexPath.row].banficaryName
            cell.completionStartAction = {
                let vc = FormVC()
                vc.viewModel.modelAssignedSurvey = self.viewModel.arrAssignedList[indexPath.row]
                vc.viewModel.isFromAssignList = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
}
extension AssignedSurveyListVC : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.viewModel.searchAssigne(strSearch: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchAssigne(strSearch: searchText)
        self.tblView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(text)
        if text == "\n" {
            searchBar.resignFirstResponder()
            return false
        }
        if let defulatText = searchBar.text,
           let textRange = Range(range, in: defulatText) {
            let updatedText = defulatText.replacingCharacters(in: textRange, with: text)
            print(updatedText)
            self.viewModel.searchAssigne(strSearch: updatedText)
            self.tblView.reloadData()
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tblView.reloadData()
    }
}

//MARK: - Filter Delegate methods
extension AssignedSurveyListVC: FilterDelegate {
    
    func filterDidApplied(state: ModelState?, district: ModelDistrict?, tehsil: ModelTehsil?, panchayat: ModelPanchayat?, village: ModelVillage?) {
        self.viewModel.selectedDistrict = district
        self.viewModel.selectedTehsil = tehsil
        self.viewModel.selectedPanchayat = panchayat
        self.viewModel.selectedVillage = village
        self.viewModel.selectedState = state
        self.viewModel.filterData()
    }
    
}
