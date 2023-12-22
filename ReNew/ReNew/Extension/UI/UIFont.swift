//
//  UIFont.swift
//  RecordingStudio
//
//  Created by mac on 17/01/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

// MARK: - UIFont's Extension
extension UIFont {
    static func SFUITextRegular(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    static func SFUITextMedium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    static func SFUITextSemibold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Semibold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    
    static func SFUITextBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
}
