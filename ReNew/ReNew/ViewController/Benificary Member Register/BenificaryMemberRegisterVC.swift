//
//  BenificaryMemberRegisterVC.swift
//  ReNew
//
//  Created by Shiyani on 29/03/24.
//

import UIKit

class BenificaryMemberRegisterVC: UIViewController {
    
    var viewModel = BenificaryMemberRegisterVM()
    
    @IBOutlet var vwMobileNumber: InputTextFeildView!
    @IBOutlet var vwSerialNumber: InputTextFeildView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }

    
    
}

//MARK: - Init Config
extension BenificaryMemberRegisterVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
    }
    
}

//MARK: - UiButton Action
extension BenificaryMemberRegisterVC {
    
    @IBAction func btnVerify(_ sender: UIButton) {
        if let msg = self.viewModel.inputValidation() {
            self.showAlert(with: msg)
            return
        }
        self.viewModel.callValidateProjectAPI()
    }
    
}

