//
//  SampleCatalog.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/// Offline stand-in for the search index, used when the API can't be reached so the journey can still be walked through.
enum SampleCatalog {

    // Groceries, to match the demo index
    static let products: [Product] = [
        Product(customerID: "demo-apple-gala", name: "Gala Apples", variationID: "demo-apple-gala-3lb", price: 4.99, details: "Crisp and sweet, 3 lb bag."),
        Product(customerID: "demo-apple-honeycrisp", name: "Honeycrisp Apple", price: 1.29, details: "Sold individually."),
        Product(customerID: "demo-apple-juice", name: "Organic Apple Juice", price: 3.79, details: "64 fl oz, not from concentrate."),
        Product(customerID: "demo-applesauce", name: "Unsweetened Applesauce Cups", price: 2.99, details: "6 pack."),
        Product(customerID: "demo-milk-whole", name: "Whole Milk", variationID: "demo-milk-whole-gal", price: 3.49, details: "1 gallon."),
        Product(customerID: "demo-milk-oat", name: "Oat Milk", price: 4.29, details: "Barista edition, 32 fl oz."),
        Product(customerID: "demo-bread-sourdough", name: "Sourdough Bread", price: 5.49, details: "Freshly baked loaf."),
        Product(customerID: "demo-bread-wheat", name: "Whole Wheat Bread", price: 3.29, details: "Sliced sandwich loaf."),
        Product(customerID: "demo-eggs", name: "Large Brown Eggs", price: 4.59, details: "One dozen, cage free."),
        Product(customerID: "demo-banana", name: "Bananas", price: 0.59, details: "Price per lb."),
        Product(customerID: "demo-coffee", name: "Medium Roast Ground Coffee", price: 9.99, details: "12 oz bag."),
        Product(customerID: "demo-cheddar", name: "Sharp Cheddar Cheese", price: 4.99, details: "8 oz block.")
    ]

    static func search(_ term: String) -> [Product] {
        let words = term.lowercased().split(separator: " ").map(String.init)
        guard !words.isEmpty else { return [] }
        return self.products.filter { product in
            let name = product.name.lowercased()
            return words.allSatisfy { word in name.contains(Self.singular(word)) }
        }
    }

    static func suggestions(for prefix: String) -> [String] {
        let prefix = prefix.lowercased()
        let words = Set(self.products.flatMap { $0.name.lowercased().split(separator: " ").map(String.init) })
        return words.filter { $0.hasPrefix(prefix) && $0.count > 2 }.sorted().prefix(5).map { $0 }
    }

    // "apples" should match "Apple"
    private static func singular(_ word: String) -> String {
        return word.count > 3 && word.hasSuffix("s") ? String(word.dropLast()) : word
    }
}
