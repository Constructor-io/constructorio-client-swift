//
//  CustomTableViewCellTwo.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorIO

class CustomTableViewCellTwo: UITableViewCell, CIOAutocompleteCell {

    func setup(title: String, searchTerm: String, highlighter: CIOHighlighter) {
        self.textLabel?.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: title)
        self.imageView?.image = UIImage(named: "icon_clock")
    }

}
