//
//  SignUpVC.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class SignUpVC: UIViewController {

    var viewModel = SignUpVM()
    
    @IBOutlet var vwProjectCode: InputTextFeildView!
    @IBOutlet var vwMobileNumber: InputTextFeildView!
    @IBOutlet var vwAadharNumber: InputTextFeildView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }

    
    
}

//MARK: - Init Config
extension SignUpVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.viewModel.userRoleUpdated()
    }
    
}

//MARK: - UiButton Action
extension SignUpVC {
    
    @IBAction func btnVerify(_ sender: UIButton) {
        if let msg = self.viewModel.inputValidation() {
            self.showAlert(with: msg)
            return
        }
        self.viewModel.callValidateProjectAPI()
    }
    
}
