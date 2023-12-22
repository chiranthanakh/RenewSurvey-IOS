//
//  UserRoleSelectionVC.swift
//  ReNew
//
//  Created by Shiyani on 13/12/23.
//

import UIKit

class UserRoleSelectionVC: UIViewController {
    
    var viewModel = UserRoleSelectionVM()
    
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }

}

//MARK: - Init Config
extension UserRoleSelectionVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.viewModel.registerController()
    }
    
}

//MARK: - UITablview Delegate & Datasource Methods
extension UserRoleSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.arrLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectSelectionTCell", for: indexPath) as? ProjectSelectionTCell else { return UITableViewCell() }
        if self.viewModel.arrLanguage.indices ~= indexPath.row {
            cell.lblProjectName.text = self.viewModel.arrLanguage[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kAppDelegate.selectedFormID = self.viewModel.arrLanguage[indexPath.row].tblFormsId
        let vc = DashboardVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


