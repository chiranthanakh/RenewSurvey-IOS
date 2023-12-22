//
//  FormGroupTitleCCell.swift
//  ReNew
//
//  Created by Shiyani on 14/12/23.
//

import UIKit

class FormGroupTitleCCell: UICollectionViewCell {

    @IBOutlet var lblGroupTitle: UILabel!
    @IBOutlet var vwProgress: UIProgressView!
    @IBOutlet var lblQuestionCount: UILabel!
    @IBOutlet var vwBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func dataBind(obj: ModelFormGroup) {
        self.lblGroupTitle.text = obj.title
        self.lblQuestionCount.text = "\(obj.questions.filter({$0.strAnswer != ""}).count)/\(obj.questions.count)"
        self.vwProgress.progress = Float(Float(obj.questions.filter({$0.strAnswer != ""}).count)/Float(obj.questions.count))
    }
}
