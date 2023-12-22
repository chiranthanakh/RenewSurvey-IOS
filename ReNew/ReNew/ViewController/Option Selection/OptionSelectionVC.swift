//
//  OptionSelectionVC.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class OptionSelectionVC: UIViewController {

    @IBOutlet var vwBg: UIView!
    
    var completionFirstSelection:((Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initConfig()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.vwBg.roundCorners(corners: [.topLeft,.topRight], radius: 20)
    }
    
}

//MARK: - Init Config
extension OptionSelectionVC {
    
    private func initConfig() {
        
    }
    
}

//MARK: - UiButton Action
extension OptionSelectionVC {
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUserAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let function = self.completionFirstSelection {
                function(true)
            }
        }
    }
    
    @IBAction func btnMemberAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if let function = self.completionFirstSelection {
                function(false)
            }
        }
    }
}
