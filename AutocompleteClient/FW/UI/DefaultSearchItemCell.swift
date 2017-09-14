//
//  DefaultSearchItemCell.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import Foundation

class DefaultSearchItemCell: UITableViewCell, CIOAutocompleteCell {

    @IBOutlet weak var labelText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(result: CIOResult, searchTerm: String, highlighter: CIOHighlighter) {
        if let group = result.group{
            let groupString = NSMutableAttributedString()
            groupString.append(NSAttributedString(string: "  in ", attributes: highlighter.attributesProvider.defaultSubstringAttributes()))
            groupString.append(NSAttributedString(string: group.displayName, attributes: highlighter.attributesProvider.highlightedSubstringAttributes()))
            self.labelText.attributedText =  groupString
        }else{
            self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.autocompleteResult.value)
        }
        
    }
}
