//
//  TestQuestionResultVC.swift
//  ReNew
//
//  Created by Shiyani on 28/12/23.
//

import UIKit

class TestQuestionResultVC: UIViewController {

    @IBOutlet var lblTestName: UILabel!
    @IBOutlet var lblTotalQuestion: UILabel!
    @IBOutlet var lblPassingMark: UILabel!
    
    var viewModel = TestQuestionResultVM()
    
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
extension TestQuestionResultVC {
    
    private func initConfig() {
        self.viewModel.viewController = self
        self.viewModel.getTestDetails()
    }
    
}

//MARK: - UiButton Action
extension TestQuestionResultVC {
    
    @IBAction func btnStartTest(_ sender: UIButton) {
        if let test = self.viewModel.modelTest {
            let vc = TestQuestionFormVC()
            vc.viewModel.modelTest = test
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
