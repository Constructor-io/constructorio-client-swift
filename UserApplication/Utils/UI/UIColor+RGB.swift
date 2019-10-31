//
//  UIColor+RGB.swift
//  UserApplication
//
//  Created by Nikola Markovic on 10/25/19.
//  Copyright © 2019 xd. All rights reserved.
//

import UIKit

extension UIColor {
    class func RGB(_ red: Int, green: Int, blue: Int) -> UIColor {
        return self.RGBA(red, green: green, blue: blue, alpha: 255)
    }

    class func RGBA(_ red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }

    class func hex(rgb: Int) -> UIColor {
        return self.RGB((rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
}
