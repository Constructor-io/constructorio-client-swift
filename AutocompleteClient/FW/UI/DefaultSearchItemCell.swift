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
        if let group = result.group {
            let groupString = NSMutableAttributedString()

            groupString.append(highlighter.highlight(searchTerm: searchTerm, itemTitle: result.autocompleteResult.value))

            let fontGroup = Constants.UI.Font.defaultFontNormal.withSize(11)
            #if swift(>=4.0)
                let groupAttributes: [String: Any] = [NSAttributedStringKey.font.rawValue: fontGroup,
                                       NSAttributedStringKey.foregroundColor.rawValue: Constants.UI.Color.defaultFontColorNormal]
            #else
                let groupAttributes: [String: Any] = [NSFontAttributeName: fontGroup,
                NSForegroundColorAttributeName: Constants.UI.Color.defaultFontColorNormal ]
            #endif

            groupString.append(NSAttributedString.build(string: "\nin \(group.displayName)", attributes: groupAttributes))
            self.labelText.attributedText = groupString
        } else {
            self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.autocompleteResult.value)
        }

    }
}
