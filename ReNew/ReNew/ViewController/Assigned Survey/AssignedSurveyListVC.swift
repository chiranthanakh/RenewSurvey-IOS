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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initConfig()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getAssignedList()
    }
}

//MARK: - Init Config
extension AssignedSurveyListVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
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
                /*let vc = FormVC()
                vc.viewModel.arrStaticQuestion = self.viewModel.arrList[indexPath.row].staticQuestions
                vc.viewModel.arrFormGroup = self.viewModel.arrList[indexPath.row].grpForm
                vc.viewModel.isFromDraft = true
                self.navigationController?.pushViewController(vc, animated: true)*/
            }
        }
        return cell
    }
}
