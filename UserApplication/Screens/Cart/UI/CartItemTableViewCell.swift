//
//  CartItemTableViewCell.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var imageViewProduct: UIImageView!

    func setup(_ model: CartItemViewModel){
        self.labelTitle.text = model.title
        self.labelQuantity.text = model.quantity.string
        self.labelTotalPrice.text = model.singleItemPrice
        self.imageViewProduct.kf.setImage(with: URL(string: model.imageURL))

        self.labelTitle.font = UIFont.appFontSemiBold(18)
        self.labelTotalPrice.font = UIFont.appFont(17)
        self.labelTotalPrice.adjustsFontSizeToFitWidth = true
        self.labelQuantity.font = UIFont.appFont(11)
    }
}
