//
//  CartViewModel.swift
//  UserApplication
//
//  Created by Nikola Markovic on 11/28/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

class CartViewModel {

    var items: [CartItemViewModel]
    let cart: Cart

    init(cart: Cart){
        self.cart = cart
        self.items = cart.items.map{ CartItemViewModel(item: $0)}
    }

    func updateQuantity(newValue: Int, for index: Int) -> CartItemViewModel?{
        if let cartItem = self.cart.updateQuantity(newValue: newValue, for: index){
            let viewModel = CartItemViewModel(item: cartItem)
            items[index] = viewModel
            return viewModel
        }else{
            self.items.remove(at: index)
            return nil
        }
    }
}
