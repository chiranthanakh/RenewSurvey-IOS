//
//  DashboardVC.swift
//  ReNew
//
//  Created by Shiyani on 13/12/23.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet var lblFormTitle: UILabel!
    @IBOutlet var lblProjectCode: UILabel!
    @IBOutlet var lblTotalSurvey: UILabel!
    @IBOutlet var lblSyncSurvey: UILabel!
    @IBOutlet var lblPendingToSync: UILabel!
    @IBOutlet var lblDraftSurvey: UILabel!
    
    var viewModel = DashboardVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.surveyCountDatabind()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

//MARK: - Init Config
extension DashboardVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        
        self.lblFormTitle.text = DataManager.getFormTitleFromFormId(formID: kAppDelegate.selectedFormID)
        self.lblProjectCode.text = DataManager.getProjectCodeFromProjectId(projectID: kAppDelegate.selectedProjectID)
    }
    
}

//MARK: - UiButton Action
extension DashboardVC {
    
    @IBAction func btnDraft(_ sender: UIButton) {
        self.navigationController?.pushViewController(DraftFromListVC(), animated: true)
    }
    
    @IBAction func btnStartNew(_ sender: UIButton) {
        if kAppDelegate.selectedFormID == 2 {
            self.navigationController?.pushViewController(AssignedSurveyListVC(), animated: true)
        }
        else {
            self.navigationController?.pushViewController(FormVC(), animated: true)
        }
    }
    
    @IBAction func btnSyncNow(_ sender: UIButton) {
        self.viewModel.getAsyncFormList()
    }
    
}
