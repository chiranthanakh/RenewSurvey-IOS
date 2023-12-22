//
//  RatingQuestionTCell.swift
//  ReNew
//
//  Created by Shiyani on 17/12/23.
//

import UIKit
import Cosmos

class RatingQuestionTCell: UITableViewCell {

    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var vwRating: CosmosView!
    @IBOutlet var vwRangeSiker: RangeSeekSlider!
    
    var completionRangeSelection:((CGFloat,CGFloat)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension RatingQuestionTCell: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if let function = self.completionRangeSelection {
            function(minValue, maxValue)
        }
    }

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
