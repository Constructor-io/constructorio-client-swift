//
//  CustomTableViewCellTwo.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class CustomTableViewCellTwo: UITableViewCell, CIOAutocompleteCell {

    func setup(result: CIOResult, searchTerm: String, highlighter: CIOHighlighter) {
        self.textLabel?.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.autocompleteResult.value)
        self.imageView?.image = UIImage(named: "icon_clock")
    }

}
