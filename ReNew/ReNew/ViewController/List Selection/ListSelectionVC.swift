//
//  ListSelectionVC.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class ListSelectionVC: UIViewController {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var txtSearchBar: UISearchBar!
    @IBOutlet var vwDoneBg: UIView!
    
    var completion:((ModelListSelection)->())?
    var completionMultipalSelection:(([ModelListSelection])->())?
    var viewModel = ListSelectionVM()
    var isMultpalSelection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }

    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnDone(_ sender: UIButton) {
        if let function = self.completionMultipalSelection {
            function(self.viewModel.arrFilterList.filter({$0.isSelected}))
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - InitConfig Methods
extension ListSelectionVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.tblView.registerCell(withNib: "ListSelectionTCell")
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.txtSearchBar.delegate = self
        
        self.lblTitle.text = self.viewModel.strTitle
        self.viewModel.dataBind(strSearch: "")
        self.txtSearchBar.isHidden = self.isMultpalSelection
        self.vwDoneBg.isHidden = !self.isMultpalSelection
        
        if self.viewModel.arrSelectedList.count > 0 {
            self.viewModel.arrFilterList.forEach { list in
                if self.viewModel.arrSelectedList.contains(list.name) {
                    list.isSelected = true
                }
            }
        }
        self.tblView.reloadData()
    }
}

//MARK: - UITablview Delegate & DataSource Method
extension ListSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrFilterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListSelectionTCell", for: indexPath) as? ListSelectionTCell else { return UITableViewCell() }
        
        cell.lblName.text = self.viewModel.arrFilterList[indexPath.row].name
        if self.isMultpalSelection {
            if self.viewModel.arrFilterList[indexPath.row].isSelected {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isMultpalSelection {
            self.viewModel.arrFilterList[indexPath.row].isSelected = !self.viewModel.arrFilterList[indexPath.row].isSelected
            self.tblView.reloadData()
        }
        else {
            if let function = self.completion {
                function(self.viewModel.arrFilterList[indexPath.row])
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UISearchBar Delegate Method
extension ListSelectionVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newString = NSString(string: searchBar.text ?? "").replacingCharacters(in: range, with: text)
        
        self.viewModel.dataBind(strSearch: newString)
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.viewModel.dataBind(strSearch: "")
        }
    }
}
