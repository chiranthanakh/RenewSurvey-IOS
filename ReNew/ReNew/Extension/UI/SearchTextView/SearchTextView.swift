//
//  SearchTextView.swift
//  LoyalInfo Loyalhospitality
//
//  Created by DREAMWORLD on 26/02/22.
//  Copyright © 2022 iMac. All rights reserved.
//

import UIKit

class SearchTextView: UIView {
    
    //MARK: Variables
    var contentView:UIView?
    let nibName = "SearchTextView"
    var searchClosedTap : (() -> Void)? = nil

    
    @IBOutlet var txtSearch: UITextField!
    @IBOutlet var btnCloseSearch: UIButton!
    
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
    
    @IBInspectable var isCloseVisible : Bool = false {
        didSet {
            self.btnCloseSearch.isHidden = !isCloseVisible
        }
    }

    
    @IBAction func btnCloseSearch(_ sender: Any) {
        if let function = self.searchClosedTap {
            function()
        }
    }
}
