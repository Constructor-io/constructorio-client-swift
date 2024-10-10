//
//  CartPersistence.swift
//  UserApplication
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import UIKit

private let kCartFileName = "Cart.json"

class CartPersistence{
    
    fileprivate var cartURL: URL{
        return FileManager.documentDirectoryURL.appendingPathComponent(kCartFileName, isDirectory: false)
    }
    
    init(){
        NotificationCenter.default.addObserver(forName: kNotificationCartDidChange, object: nil, queue: OperationQueue.main, using: self.cartDidChange(_:))
    }
    
    @discardableResult
    func save(cart: Cart) -> Bool{
        do{
            let data = try JSONEncoder().encode(cart)
            try data.write(to: self.cartURL, options: .atomic)
            return true
        }catch{
            return false
        }
    }
    
    func loadCart() -> Cart?{
        do{
            let data = try Data(contentsOf: self.cartURL)
            return try JSONDecoder().decode(Cart.self, from: data)
        }catch{
            return nil
        }
    }
}

// MARK: Cart monitoring
extension CartPersistence{
    func cartDidChange(_ notification: Notification){
        guard let cart = notification.cart() else { return }
        self.save(cart: cart)
    }
}

extension FileManager {
    static var documentDirectoryURL: URL {
        let documentDirectoryURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documentDirectoryURL
    }
}
