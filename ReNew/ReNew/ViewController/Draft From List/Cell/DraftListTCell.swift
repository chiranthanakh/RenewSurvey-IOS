//
//  DraftListTCell.swift
//  ReNew
//
//  Created by Shiyani on 22/12/23.
//

import UIKit

class DraftListTCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    
    var completionStartAction:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnStart(_ sender: UIButton) {
        if let function = self.completionStartAction {
            function()
        }
    }
}
