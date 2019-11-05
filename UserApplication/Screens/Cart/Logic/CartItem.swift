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
    let price: Double
    var totalPrice: Double {
        return self.price * Double(self.quantity)
    }
    var quantity: Int
    
}
