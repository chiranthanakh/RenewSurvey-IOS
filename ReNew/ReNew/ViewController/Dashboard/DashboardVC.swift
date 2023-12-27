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
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblUserPhoneNo: UILabel!
    @IBOutlet var lblUserEmail: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var vwSideMenuBg: UIView!
    @IBOutlet var menuLeading: NSLayoutConstraint!
    @IBOutlet var vwBlackWrapper: UIView!
    @IBOutlet var imgProfile: UIImageView!
    
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
        self.viewModel.registerController()
        self.lblFormTitle.text = DataManager.getFormTitleFromFormId(formID: kAppDelegate.selectedFormID)
        self.lblProjectCode.text = DataManager.getProjectCodeFromProjectId(projectID: kAppDelegate.selectedProjectID)
    }
    
    func hideMenu() {
        self.vwBlackWrapper.isHidden = true
        self.vwSideMenuBg.isHidden = true
    }
}

//MARK: - UiButton Action
extension DashboardVC {
    
    @IBAction func btnDraft(_ sender: UIButton) {
        self.navigationController?.pushViewController(DraftFromListVC(), animated: true)
    }
    
    @IBAction func btnStartNew(_ sender: UIButton) {
        if kAppDelegate.selectedFormID == 1 {
            self.navigationController?.pushViewController(FormVC(), animated: true)
        }
        else {
            let vc = AssignedSurveyListVC()
            vc.viewModel.selectedformType = .Distribution
            self.navigationController?.pushViewController(AssignedSurveyListVC(), animated: true)
        }
    }
    
    @IBAction func btnSyncNow(_ sender: UIButton) {
        self.viewModel.getAsyncFormList()
    }
    
    @IBAction func btnShowMenu(_ sender: UIButton) {
        self.vwBlackWrapper.isHidden = false
        self.vwSideMenuBg.isHidden = false
    }
    
    @IBAction func btnHideMenu(_ sender: UIButton) {
        self.hideMenu()
    }
}

//MARK: - UITablview Delegate & Datasource Methods
extension DashboardVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTCell", for: indexPath) as? MenuTCell else { return UITableViewCell() }
        
        if indexPath.row == 0 {
            cell.imgOption.image = UIImage(systemName: "bell.fill")
            cell.lblOptionTitle.text = "Notification"
        }
        else if indexPath.row == 1 {
            cell.imgOption.image = UIImage(systemName: "lock.fill")
            cell.lblOptionTitle.text = "Change password"
        }
        else if indexPath.row == 2 {
            cell.imgOption.image = UIImage(named: "ic_LogOut")
            cell.lblOptionTitle.text = "LogOut"
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }
        else if indexPath.row == 1 {
            self.hideMenu()
            let vc = ResetPasswordVC()
            vc.dicParam = ["mobile": ModelUser.getCurrentUserFromDefault()?.mobile ?? "",
                           "tbl_users_id": ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? ""]
            vc.isFromChangePassword = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            self.showAlert(with: "Do you want to logout?", firstButton: "yes", firstHandler: { _ in
                ModelUser.removeUserFromDefault()
                kAppDelegate.setLogInScreen()
            }, secondButton: "No") { _ in
                
            }
        }
    }
}
