//
//  BoldAttributesProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class BoldAttributesProvider: CIOHighlightingAttributesProvider {

    var fontNormal: UIFont
    var fontBold: UIFont
    
    var colorNormal: UIColor
    var colorBold: UIColor

    init(fontNormal: UIFont, fontBold: UIFont, colorNormal: UIColor, colorBold: UIColor) {
        self.colorNormal = colorNormal
        self.colorBold = colorBold
        self.fontNormal = fontNormal
        self.fontBold = fontBold
    }

    func defaultSubstringAttributes() -> [String: Any] {
        #if swift(>=4.0)
            
            return [NSAttributedStringKey.font.rawValue: self.fontBold,
                    NSAttributedStringKey.foregroundColor.rawValue: self.colorBold]
        #else
            return [NSFontAttributeName: self.fontBold,
                    NSForegroundColorAttributeName: self.colorBold]
        #endif
    }

    func highlightedSubstringAttributes() -> [String: Any] {
        #if swift(>=4.0)
            return [NSAttributedStringKey.font.rawValue: self.fontNormal,
                    NSAttributedStringKey.foregroundColor.rawValue: self.colorNormal]
        #else
            return [NSFontAttributeName: self.fontNormal,
                    NSForegroundColorAttributeName: self.colorBold]
        #endif
    }
}
