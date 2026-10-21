//
//  Product.swift
//  ConstructorDemo
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import Foundation

struct Product: Identifiable, Hashable {
    let customerID: String
    let name: String
    let variationID: String?
    let price: Double?
    let imageURL: URL?
    let details: String?
    let url: String?

    // Variations of the same item share a customer ID, so both are needed to be unique
    var id: String {
        return "\(self.customerID)|\(self.variationID ?? "")"
    }

    var cioItem: CIOItem {
        return CIOItem(customerID: self.customerID, itemName: self.name, variationID: self.variationID)
    }

    init(customerID: String, name: String, variationID: String? = nil, price: Double? = nil, imageURL: URL? = nil, details: String? = nil, url: String? = nil) {
        self.customerID = customerID
        self.name = name
        self.variationID = variationID
        self.price = price
        self.imageURL = imageURL
        self.details = details
        self.url = url
    }

    init?(result: CIOResult) {
        guard let customerID = result.data.id else { return nil }
        self.init(
            customerID: customerID,
            name: result.value,
            variationID: result.data.variationId,
            price: Product.price(from: result.data.metadata),
            imageURL: result.data.imageURL.flatMap(URL.init(string:)),
            details: result.data.description,
            url: result.data.url
        )
    }

    // Indexes store price under different keys and types, so try the common ones
    private static func price(from metadata: [String: Any]) -> Double? {
        for key in ["price", "sale_price", "list_price"] {
            switch metadata[key] {
            case let value as Double:
                return value
            case let value as Int:
                return Double(value)
            case let value as String:
                if let parsed = Double(value) { return parsed }
            default:
                continue
            }
        }
        return nil
    }
}

extension Optional where Wrapped == Double {
    var formattedPrice: String {
        guard let value = self else { return "—" }
        return value.formatted(.currency(code: "USD"))
    }
}
