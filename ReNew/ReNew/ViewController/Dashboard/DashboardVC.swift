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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
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
        self.lblFormTitle.text = DataManager.getFormTitleFromFormId(formID: kAppDelegate.selectedFormID)
        self.lblProjectCode.text = DataManager.getProjectCodeFromProjectId(projectID: kAppDelegate.selectedProjectID)
    }
    
}

//MARK: - UiButton Action
extension DashboardVC {
    
    @IBAction func btnStartNew(_ sender: UIButton) {
        self.navigationController?.pushViewController(FormVC(), animated: true)
    }
    
}
