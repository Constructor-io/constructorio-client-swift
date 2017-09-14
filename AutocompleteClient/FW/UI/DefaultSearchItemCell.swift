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
            self.labelText.text = "in \(group.displayName)"
        }else{
            self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.autocompleteResult.value)
        }
        
    }
}
