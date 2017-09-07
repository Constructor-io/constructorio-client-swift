//
//  CustomAttributesProvider.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorIO

class CustomAttributesProvider: CIOHighlightingAttributesProvider {

    func defaultSubstringAttributes() -> [String: Any] {
        return [NSForegroundColorAttributeName: UIColor.darkGray, NSFontAttributeName: UIFont(name: "Optima-Regular", size: 15)!]
    }

    func highlightedSubstringAttributes() -> [String: Any] {
        return [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "Optima-Bold", size: 15)!]
    }

}
