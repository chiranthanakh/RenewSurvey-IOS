//
//  MenuTCell.swift
//  ReNew
//
//  Created by Shiyani on 25/12/23.
//

import UIKit

class MenuTCell: UITableViewCell {

    @IBOutlet var imgOption: UIImageView!
    @IBOutlet var lblOptionTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //bell.fill
        //lock.fill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
