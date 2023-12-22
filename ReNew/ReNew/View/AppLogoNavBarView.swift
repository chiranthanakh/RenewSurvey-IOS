//
//  AppLogoNavBarView.swift
//  ReNew
//
//  Created by Shiyani on 09/12/23.
//

import Foundation


class AppLogoNavBarView: UIView {
    
    var contentView:UIView?
    let nibName = "AppLogoNavBarView"
    var completion:(()->())?

    var isFromTraineeEnrollment = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
