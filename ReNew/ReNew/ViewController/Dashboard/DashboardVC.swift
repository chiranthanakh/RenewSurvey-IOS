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
    var arrMenuOption : [SideMenuOption] = [.Profile,.Notification,.ChangePassword,.LogOut]
    
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
        self.lblProjectCode.text = ("\(DataManager.getProjectCodeFromProjectId(projectID: kAppDelegate.selectedProjectID).0) v\(DataManager.getProjectCodeFromProjectId(projectID: kAppDelegate.selectedProjectID).1)")
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
        return self.arrMenuOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTCell", for: indexPath) as? MenuTCell else { return UITableViewCell() }
        
        cell.imgOption.image = self.arrMenuOption[indexPath.row].igmIcon
        cell.lblOptionTitle.text = self.arrMenuOption[indexPath.row].strTitle
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrMenuOption[indexPath.row] == .Profile {
            self.navigationController?.pushViewController(ProfileVC(), animated: true)
        }
        else if self.arrMenuOption[indexPath.row] == .ChangePassword {
            self.hideMenu()
            let vc = ResetPasswordVC()
            vc.dicParam = ["mobile": ModelUser.getCurrentUserFromDefault()?.mobile ?? "",
                           "tbl_users_id": ModelUser.getCurrentUserFromDefault()?.tblUsersId ?? ""]
            vc.isFromChangePassword = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if self.arrMenuOption[indexPath.row] == .LogOut {
            self.showAlert(with: "Do you want to logout?", firstButton: "Yes", firstHandler: { _ in
                ModelUser.removeUserFromDefault()
                kAppDelegate.setLogInScreen()
            }, secondButton: "No") { _ in
                
            }
        }
    }
}
