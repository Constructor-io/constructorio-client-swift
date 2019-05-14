//
//  SortOptionTableViewCell.swift
//  UserApplication
//
//  Created by Nikola Markovic on 5/14/19.
//  Copyright © 2019 xd. All rights reserved.
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
