//
//  UIStoryboard+Name.swift
//  RecordingStudio
//
//  Created by mac on 16/01/2020.
//  Copyright © 2019 Differenzsystem Pvt. LTD. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    func getViewController(with identifier: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier: identifier)
    }
    
    class func getStoryboard(for name: String) -> UIStoryboard {
        return UIStoryboard(name: name, bundle: nil)
    }
    
}
