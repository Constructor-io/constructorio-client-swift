//
//  BoldAttributesProvider.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class BoldAttributesProvider: CIOHighlightingAttributesProvider {

    public var fontNormal: UIFont
    public var fontBold: UIFont

    public var colorNormal: UIColor
    public var colorBold: UIColor

    public init(fontNormal: UIFont, fontBold: UIFont, colorNormal: UIColor, colorBold: UIColor) {
        self.colorNormal = colorNormal
        self.colorBold = colorBold
        self.fontNormal = fontNormal
        self.fontBold = fontBold
    }
    public func defaultSubstringAttributes() -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: self.fontBold,
                    NSAttributedString.Key.foregroundColor: self.colorBold]
    }

    public func highlightedSubstringAttributes() -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: self.fontNormal,
                    NSAttributedString.Key.foregroundColor: self.colorNormal]
    }
}
