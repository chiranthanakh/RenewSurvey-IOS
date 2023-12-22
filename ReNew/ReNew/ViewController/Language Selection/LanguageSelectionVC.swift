//
//  LanguageSelectionVC.swift
//  ReNew
//
//  Created by Shiyani on 12/12/23.
//

import UIKit

class LanguageSelectionVC: UIViewController {

    var viewModel = LanguageSelectionVM()
    
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }

}

//MARK: - Init Config
extension LanguageSelectionVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.viewModel.registerController()
    }
    
}

//MARK: - UITablview Delegate & Datasource Methods
extension LanguageSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.arrLanguage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageSelectionTCell", for: indexPath) as? LanguageSelectionTCell else { return UITableViewCell() }
        if self.viewModel.arrLanguage.indices ~= indexPath.row {
            cell.lblLanguage.text = self.viewModel.arrLanguage[indexPath.row].title
            cell.lblSymbol.text = self.viewModel.arrLanguage[indexPath.row].symbol.localizedCapitalized
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        kAppDelegate.selectedLanguageID = self.viewModel.arrLanguage[indexPath.row].mstLanguageId
        let vc = ProjectSelectionVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
