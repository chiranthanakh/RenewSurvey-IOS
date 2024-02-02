//
//  PendingApprovalVC.swift
//  ReNew
//
//  Created by Shiyani on 18/12/23.
//

import UIKit

class PendingApprovalVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBackToLogin(_ sender: Any) {
        kAppDelegate.setLogInScreen()
    }
}
