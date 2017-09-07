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
        return [NSFontAttributeName: self.fontNormal]
    }

    func highlightedSubstringAttributes() -> [String: Any] {
        return [NSFontAttributeName: self.fontBold]
    }
}
