//
//  CIOItem.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOItem {
    var customerID: String
    var variationID: String?
    var quantity: Int?

    public init(customerID: String, variationID: String? = nil, quantity: Int? = nil) {
        self.customerID = customerID
        self.variationID = variationID
        self.quantity = quantity
    }
}
