//
//  CartItem.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

struct CartItem: Codable{
    let title: String
    let imageURL: String
    let price: Float
    var totalPrice: Float{
        return self.price * Float(self.quantity)
    }
    var quantity: Int
    
}
