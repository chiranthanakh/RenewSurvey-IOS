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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL (string: AppConstant.Link.Terms) {
            let requestObj = URLRequest(url: url)
            self.webView.load(requestObj)
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
