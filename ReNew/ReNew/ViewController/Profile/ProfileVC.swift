//
//  ProfileVC.swift
//  ReNew
//
//  Created by Shiyani on 29/12/23.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblMobileNumber: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblAdharcard: UILabel!
    @IBOutlet var lblUserId: UILabel!
    @IBOutlet var lblUserType: UILabel!
    @IBOutlet var lblPinCode: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }


}

//MARK: - Init Config
extension ProfileVC {
    
    private func initConfig() {
        if let user = ModelUser.getCurrentUserFromDefault() {
            self.imgProfile.setImage(withUrl: user.profilePhoto)
            self.lblUserName.text = user.fullName
            self.lblMobileNumber.text = "Mobile: \(user.mobile ?? "")"
            self.lblEmail.text = "Email: \(user.email ?? "")"
            self.lblAdharcard.text = "Aadhaarcard: \(user.aadharCard ?? "")"
            self.lblUserId.text = "User Id: \(user.tblUsersId ?? "")"
            self.lblUserType.text = "User type: \(user.userType ?? "")"
            self.lblPinCode.text = "Pincode: \(user.pincode ?? "")"
            self.lblAddress.text = "Address: \(user.address ?? "")"
        }
    }
    
}
