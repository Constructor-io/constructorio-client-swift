//
//  SearchCollectionViewCell.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit
import Kingfisher

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 6
        self.contentView.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.masksToBounds = true
        self.contentView.clipsToBounds = true
    }

    func setup(viewModel: SearchResultViewModel){
        self.labelProductName.text = viewModel.title
        self.labelPrice.text = viewModel.price

        self.imageView.kf.setImage(with: URL(string: viewModel.imageURL), placeholder: viewModel.fallbackImage())
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.kf.cancelDownloadTask()
    }

}
