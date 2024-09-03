//
//  CIOItem.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
