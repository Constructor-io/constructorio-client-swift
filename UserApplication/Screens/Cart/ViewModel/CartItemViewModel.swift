//
//  CartItemViewModel.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

struct CartItemViewModel {
    let title: String
    let imageURL: String
    let singleItemPrice: String
    let totalPrice: String
    var quantity: Quantity

    init(item: CartItem){
        self.title = item.title
        self.quantity = Quantity(value: item.quantity)
        self.imageURL = item.imageURL
        self.singleItemPrice = String(format: "$%.2f",item.price)
        self.totalPrice = String(format: "$%.2f",item.totalPrice)
    }

}
