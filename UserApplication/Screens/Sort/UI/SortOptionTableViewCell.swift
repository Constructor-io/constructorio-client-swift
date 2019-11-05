//
//  SortOptionTableViewCell.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class SortOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var labelSort: UILabel!
    @IBOutlet weak var imageViewSort: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.contentMode = .scaleAspectFit
    }

}
