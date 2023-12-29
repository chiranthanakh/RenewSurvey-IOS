//
//  TermsConditionVC.swift
//  ReNew
//
//  Created by Shiyani on 27/12/23.
//

import UIKit
import WebKit

class TermsConditionVC: UIViewController {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var lblTitle: UILabel!
    
    var urlFile: URL?
    var isFromTerms = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if isFromTerms, let url = URL (string: AppConstant.Link.Terms) {
            self.webView.load(URLRequest(url: url))
        }
        else if let url = self.urlFile{
            self.lblTitle.text = "Tutorial File"
            self.webView.load(URLRequest(url: url))
        }
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
