//
//  DetailsViewModel.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation
import UIKit

struct DetailsViewModel{
    let title: String
    let price: Double
    var priceString: String{
        return "$\(self.price)"
    }
    let image: UIImage?
    let imageURL: String
    let description: String
    
    var titlePrice: String{
        return "\(self.title)\n\n\(self.priceString)"
    }

    let cart: Cart

}
