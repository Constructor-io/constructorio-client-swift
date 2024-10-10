//
//  CustomTableViewCellTwo.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class CustomTableViewCellTwo: UITableViewCell, CIOAutocompleteCell {

    func setup(result: CIOAutocompleteResult, searchTerm: String, highlighter: CIOHighlighter) {
        if let group = result.group{
            let groupString = NSMutableAttributedString()
            groupString.append(NSAttributedString(string: "  in ", attributes: highlighter.attributesProvider.defaultSubstringAttributes()))
            groupString.append(NSAttributedString(string: group.displayName, attributes: highlighter.attributesProvider.highlightedSubstringAttributes()))
            self.textLabel?.attributedText =  groupString
            
            self.imageView?.image = nil
        }else{
            self.textLabel?.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.result.value)
            self.imageView?.image = UIImage(named: "icon_clock")
        }
    }

}
