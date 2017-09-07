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

    func setup(title: String, searchTerm: String, highlighter: CIOHighlighter) {
        self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: title)
    }
}
