//
//  LanguageSelectionTCell.swift
//  ReNew
//
//  Created by Shiyani on 12/12/23.
//

import UIKit

class LanguageSelectionTCell: UITableViewCell {

    @IBOutlet var lblLanguage: UILabel!
    @IBOutlet var lblSymbol: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
