//
//  CartViewModel.swift
//  UserApplication
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

class CartViewModel {

    var items: [CartItemViewModel]
    let cart: Cart
    let constructor: ConstructorIO

    var totalPrice: String{
        return String(format: "$%.02f", cart.items.map({ $0.totalPrice }).reduce(0, +))
    }
    
    init(cart: Cart, constructor: ConstructorIO){
        self.cart = cart
        self.constructor = constructor
        self.items = []
        self.reloadItems()
    }

    func reloadItems(){
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

    func removeItemAtIndex(_ index: Int){
        self.cart.items.remove(at: index)
        self.reloadItems()
    }

    func removeAllItems(){
        self.cart.items = []
        self.reloadItems()
    }
}
