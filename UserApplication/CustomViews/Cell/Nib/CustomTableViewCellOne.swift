//
//  CustomTableViewCellOne.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import ConstructorAutocomplete

class CustomTableViewCellOne: UITableViewCell, CIOAutocompleteCell {

    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelText: UILabel!

    var randomImage: UIImage {
        var imageNames = ["icon_clock", "icon_error_yellow", "icon_help", "icon_sign_error", "icon_star"]
        let name = imageNames[Int(arc4random()) % imageNames.count]
        return UIImage(named: name)!
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(result: CIOResult, searchTerm: String, highlighter: CIOHighlighter) {
        self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.value)
        self.imageViewIcon.image = self.randomImage
    }

}
