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

    init(fontNormal: UIFont, fontBold: UIFont) {
        self.fontNormal = fontNormal
        self.fontBold = fontBold
    }

    func defaultSubstringAttributes() -> [String: Any] {
        #if swift(>=4.0)
            return [NSAttributedStringKey.font.rawValue: self.fontNormal]
        #else
            return [NSFontAttributeName: self.fontNormal]
        #endif
    }

    func highlightedSubstringAttributes() -> [String: Any] {
        #if swift(>=4.0)
          return [NSAttributedStringKey.font.rawValue: self.fontBold]
        #else
            return [NSFontAttributeName: self.fontBold]
        #endif
    }
}
