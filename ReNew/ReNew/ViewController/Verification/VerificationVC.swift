//
//  VerificationVC.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit
import AEOTPTextField

class VerificationVC: UIViewController {

    @IBOutlet var vwOTP: AEOTPTextField!
    @IBOutlet var btnResendOTP: UIButton!
    
    
    var viewModel = VerificationVM()
    var timer = Timer()
    var intResendCountdown = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }
   
}

//MARK: - Init Config
extension VerificationVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.setUpOTPView()
        self.runTimer()
    }
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            if self.intResendCountdown == 0 {
                self.timer.invalidate()
                self.btnResendOTP.setTitle("Resend", for: .normal)
            }
            else {
                self.btnResendOTP.setTitle("\(self.intResendCountdown) Sec", for: .normal)
                self.intResendCountdown-=1
            }
        })
    }
    
    private func setUpOTPView(){
        self.vwOTP.otpDelegate = self
        self.vwOTP.otpFilledBackgroundColor = .white
        self.vwOTP.otpBackgroundColor = .white
        self.vwOTP.otpDefaultBorderColor = UIColor(named: "AppThemeGreenColor") ?? .black
        self.vwOTP.otpDefaultBorderWidth = 1
        self.vwOTP.otpFilledBorderWidth = 1
        self.vwOTP.otpFilledBorderColor = UIColor(named: "AppThemeGreenColor") ?? .black
        self.vwOTP.otpFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        self.vwOTP.configure(with: 4)
        self.vwOTP.becomeFirstResponder()
        self.vwOTP.clearOTP()
    }
    
}

//MARK: - UiButton Action
extension VerificationVC {
    
    @IBAction func btnVerify(_ sender: UIButton) {
        if self.viewModel.inputOTP == self.viewModel.validtedOTP {
            //Success
            if self.viewModel.isFromForgotPassword {
                let vc = ResetPasswordVC()
                vc.dicParam = self.viewModel.dicResedParam
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = RegistrationVC()
                vc.viewModel.dicVericifationParam = self.viewModel.dicResedParam
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else {
            self.showAlert(with: "Please enter valid OTP.")
        }
    }
    
    @IBAction func btnResendOTP(_ sender: UIButton) {
        if self.intResendCountdown == 0{
            if self.viewModel.isFromForgotPassword {
                self.viewModel.resendVerifyOTP()
            }
            else {
                self.viewModel.resendOTP()
            }
        }
    }
    
}

//MARK: - AEOTP TextField Delegate Method
extension VerificationVC: AEOTPTextFieldDelegate {
    
    func didUserFinishEnter(the code: String) {
        print(code)
        self.viewModel.inputOTP = code
    }
    
}
