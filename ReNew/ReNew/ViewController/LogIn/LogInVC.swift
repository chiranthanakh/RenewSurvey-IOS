//
//  LogInVC.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class LogInVC: UIViewController {

    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var txtMobile: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
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
extension LogInVC {
    
    private func initConfig() {
        self.btnSignUp.titleLabel?.numberOfLines = 2
    }
    
    func inputValidation() -> String? {
        if (self.txtMobile.text?.count ?? 0) < 10 {
            return "Please entr valid mobile number."
        }
        else if self.txtPassword.text == "" {
            return "Please entr password"
        }
        return nil
    }
    
    func callLogInAPI() {
        let param = ["password": self.txtPassword.text ?? "",
                     "mobile": self.txtMobile.text ?? "",
                     "app_key": AppConstant.Key.appKey] as [String : Any]
        
        APIManager.sharedInstance.makeRequest(with: AppConstant.API.kLogin, method: .post, parameter: param) { error, dict in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let responsedic = dict {
                if (responsedic["success"] as? String ?? "") == "1" {
                    if let data = responsedic["data"] as? [String:Any] {
                        let user = ModelUser.init(fromDictionary: data)
                        user.saveCurrentUserInDefault()
                        self.showAlert(with: data["message"] as? String ?? "", firstHandler:  { action in
                            kAppDelegate.setSyncScreen()
                        })
                    }
                }
                else {
                    self.showAlert(with: responsedic["message"] as? String ?? "")
                }
            }
        }
    }
    
}
//MARK: - UiButton Action
extension LogInVC {
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        let vc = OptionSelectionVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.completionFirstSelection = { isFirstSelection in
            let vc = SignUpVC()
            if isFirstSelection {
                vc.viewModel.selecteduserRole = .User
            }
            else {
                vc.viewModel.selecteduserRole = .Member
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func btnSignIn(_ sender: UIButton) {
        if let msg = self.inputValidation() {
            self.showAlert(with: msg)
            return
        }
        self.callLogInAPI()
    }
    
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(ForgotPasswordVC(), animated: true)
    }
}
