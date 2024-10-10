//
//  CustomAttributesProvider.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class CustomAttributesProvider: CIOHighlightingAttributesProvider {

    func defaultSubstringAttributes() -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont(name: "Optima-Regular", size: 15)!]
    }

    func highlightedSubstringAttributes() -> [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Optima-Bold", size: 15)!]
    }

}
