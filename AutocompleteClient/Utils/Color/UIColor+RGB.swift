//
//  UIColor+RGB.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public extension UIColor {
    public class func RGB(_ red: Int, green: Int, blue: Int) -> UIColor {
        return self.RGBA(red, green: green, blue: blue, alpha: 255)
    }

    public class func RGBA(_ red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }

    public class func hex(rgb: Int) -> UIColor {
        return self.RGB((rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF)
    }
}
