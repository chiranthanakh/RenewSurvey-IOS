//
//  PendingSyncFormScreenVC.swift
//  ReNew
//
//  Created by Shiyani on 28/12/23.
//

import UIKit

class PendingSyncFormScreenVC: UIViewController {

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
    @IBAction func btnSyncnow(_ sender: UIButton) {
        if DataManager.getAllDraftFromList().count > 0{
            self.showAlert(with: "Your draft forms are going to erase", firstHandler:  { action in
                DataManager.syncWithServer {
                    self.navigationController?.pushViewController(SyncServerVC(), animated: true)
                }
            })
        }
        else {
            DataManager.syncWithServer {
                self.navigationController?.pushViewController(SyncServerVC(), animated: true)
            }
        }
    }
    
}
