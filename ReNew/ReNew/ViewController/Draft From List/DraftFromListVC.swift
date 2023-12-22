//
//  DraftFromListVC.swift
//  ReNew
//
//  Created by Shiyani on 22/12/23.
//

import UIKit

class DraftFromListVC: UIViewController {

    var viewModel = DraftFromListVM()
    
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initConfig()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getDraftFormList()
    }
}

//MARK: - Init Config
extension DraftFromListVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.viewModel.registerController()
    }
    
}

//MARK: - UITablview Delegate & Datasource Methods
extension DraftFromListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DraftListTCell", for: indexPath) as? DraftListTCell else { return UITableViewCell() }
        
        if self.viewModel.arrList.indices ~= indexPath.row {
            cell.lblTitle.text = self.viewModel.arrList[indexPath.row].staticQuestions.first?.strAnswer ?? ""
            cell.completionStartAction = {
                let vc = FormVC()
                vc.viewModel.arrStaticQuestion = self.viewModel.arrList[indexPath.row].staticQuestions
                vc.viewModel.arrFormGroup = self.viewModel.arrList[indexPath.row].grpForm
                vc.viewModel.isFromDraft = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
}
