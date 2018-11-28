//
//  CartItemViewModel.swift
//  UserApplication
//
//  Created by Nikola Markovic on 11/28/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit

struct CartItemViewModel {
    let title: String
    let imageURL: String
    let totalPrice: String
    var quantity: Quantity

    init(item: CartItem){
        self.title = item.title
        self.quantity = Quantity(value: item.quantity)
        self.imageURL = item.imageURL
        self.totalPrice = String(format: "%.2f$",item.totalPrice)
    }

}
