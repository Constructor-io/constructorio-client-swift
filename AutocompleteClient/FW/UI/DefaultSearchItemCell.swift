//
//  DefaultSearchItemCell.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public class DefaultSearchItemCell: UITableViewCell, CIOAutocompleteCell {

    @IBOutlet public weak var labelText: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setup(result: CIOAutocompleteResult, searchTerm: String, highlighter: CIOHighlighter) {
        if let group = result.group {
            let groupString = NSMutableAttributedString()

            groupString.append(highlighter.highlight(searchTerm: searchTerm, itemTitle: result.result.value))

            let fontGroup = Constants.UI.Font.defaultFontNormal.withSize(11)
            let groupAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: fontGroup,
                                       NSAttributedString.Key.foregroundColor: Constants.UI.Color.defaultFontColorNormal]

            groupString.append(NSAttributedString.build(string: "\nin \(group.displayName)", attributes: groupAttributes))
            self.labelText.attributedText = groupString
        } else {
            self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.result.value)
        }

    }
}
