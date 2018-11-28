//
//  CartItemTableViewCell.swift
//  UserApplication
//
//  Created by Nikola Markovic on 11/27/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var stepperQuantity: UIStepper!
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var imageViewProduct: UIImageView!

    var index: Int?

    var onStepperValueChanged: ((_ sender: CartItemTableViewCell, _ newValue: Int, _ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.stepperQuantity.stepValue = 1
        self.stepperQuantity.maximumValue = 999
        self.stepperQuantity.minimumValue = 1

        self.stepperQuantity.addTarget(self, action: #selector(didTapOnStepper), for: .valueChanged)
    }

    func setup(_ model: CartItemViewModel, index: Int){
        self.labelTitle.text = model.title
        self.labelQuantity.text = model.quantity.string
        self.stepperQuantity.value = Double(model.quantity.value)
        self.labelTotalPrice.text = model.totalPrice
        self.imageViewProduct.kf.setImage(with: URL(string: model.imageURL))


        self.index = index
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.index = nil
    }

    func didTapOnStepper(){
        guard let index = self.index else { return }

        self.onStepperValueChanged?(self, Int(self.stepperQuantity.value), index)
    }
}
