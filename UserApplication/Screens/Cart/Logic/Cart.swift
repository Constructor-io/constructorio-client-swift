//
//  Cart.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

let kNotificationCartDidChange = Notification.Name(rawValue: "kNotificationCartDidChange")
let kNotificationDidAddItemToCart = Notification.Name(rawValue: "kNotificationDidAddItemToCart")

let kKeyCartItem = "kKeyCartItem"
let kKeyCart = "kKeyCart"

class Cart: NSObject, Codable{
    
    var items: [CartItem] = [] {
        didSet{
            NotificationCenter.default.post(name: kNotificationCartDidChange, object: nil, userInfo: [kKeyCart: self])
        }
    }
    
    var quantity: Int{
        return self.items.reduce(0, { $0 + $1.quantity })
    }
    
    func addItem(_ toAdd: CartItem){
        if let idx = items.firstIndex(where: { (item) -> Bool in item.title == toAdd.title }) {
            var item = items[idx]
            item.quantity += 1
            items[idx] = item
        }else{
            self.items.append(toAdd)
        }
        
        NotificationCenter.default.post(name: kNotificationDidAddItemToCart, object: nil, userInfo: [kKeyCartItem: toAdd, kKeyCart: self])
    }
    
    func updateQuantity(newValue: Int, for index: Int) -> CartItem?{
        if newValue == 0{
            self.items.remove(at: index)
            return nil
        }else{
            var item = items[index]
            item.quantity = newValue
            self.items[index] = item
            return item
        }
    }
    
}

extension Notification{
    func cartItem() -> CartItem?{
        return self.userInfo?[kKeyCartItem] as? CartItem
    }
    
    func cart() -> Cart?{
        return self.userInfo?[kKeyCart] as? Cart
    }
}
