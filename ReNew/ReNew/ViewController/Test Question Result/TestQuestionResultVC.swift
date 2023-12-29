//
//  TestQuestionResultVC.swift
//  ReNew
//
//  Created by Shiyani on 28/12/23.
//

import UIKit
import AVKit

class TestQuestionResultVC: UIViewController {

    @IBOutlet var lblTestName: UILabel!
    @IBOutlet var lblTotalQuestion: UILabel!
    @IBOutlet var lblPassingMark: UILabel!
    @IBOutlet var vwVideoPreview: UIView!
    @IBOutlet var vwPdfPreview: UIView!
    
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
    
    func playVideo(videoUrl: URL) {
        let player = AVPlayer(url: videoUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
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
    
    @IBAction func btnPreviewPdf(_ sender: UIButton) {
        if let test = self.viewModel.modelTest {
            if let url = CacheManager.shared.checkIfFileExist(stringUrl: test.tutorial) {
                let vc = TermsConditionVC()
                vc.isFromTerms = false
                vc.urlFile = url
                self.present(vc, animated: true)
            }
            else {
                if let filePath = UserDefaults.trainingTutorials.filter({$0.contains(test.tutorial)}).first, let url = URL(string: filePath) {
                    let vc = TermsConditionVC()
                    vc.isFromTerms = false
                    vc.urlFile = url
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func btnPreviewVideo(_ sender: UIButton) {
        if let test = self.viewModel.modelTest {
            if let url = CacheManager.shared.checkIfFileExist(stringUrl: test.tutorial) {
                self.playVideo(videoUrl: url)
            }
            else {
                if let filePath = UserDefaults.trainingTutorials.filter({$0.contains(test.tutorial)}).first, let url = URL(string: filePath) {
                    self.playVideo(videoUrl: url)
                }
            }
        }
    }
}
