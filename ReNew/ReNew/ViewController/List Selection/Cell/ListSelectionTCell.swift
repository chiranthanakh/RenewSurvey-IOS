//
//  ListSelectionTCell.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import UIKit

class ListSelectionTCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
