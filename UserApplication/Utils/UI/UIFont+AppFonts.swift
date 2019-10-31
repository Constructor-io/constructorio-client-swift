//
//  UIFont+AppFonts.swift
//  UserApplication
//
//  Created by Nikola Markovic on 10/25/19.
//  Copyright © 2019 xd. All rights reserved.
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
