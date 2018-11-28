//
//  CartItem.swift
//  UserApplication
//
//  Created by Nikola Markovic on 11/27/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit

struct CartItem{
    let title: String
    let imageURL: String
    let price: Float
    var totalPrice: Float{
        return self.price * Float(self.quantity)
    }
    var quantity: Int

}
