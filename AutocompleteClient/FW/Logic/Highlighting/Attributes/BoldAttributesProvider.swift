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


    public func defaultSubstringAttributes() -> [NSAttributedStringKey: Any]{
        return [NSAttributedStringKey.font: self.fontBold,
                NSAttributedStringKey.foregroundColor: self.colorBold]
    }

    public func highlightedSubstringAttributes() -> [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: self.fontNormal,
                    NSAttributedStringKey.foregroundColor: self.colorNormal]
    }
}
