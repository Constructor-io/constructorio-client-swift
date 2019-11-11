//
//  UIFont+AppFonts.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

extension UIFont{
    static func appFontSemiBold(_ size: CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func appFontBold(_ size: CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func appFont(_ size: CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize: size)
    }
}
