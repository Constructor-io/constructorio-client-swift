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
    
    public init(customerID: String, variationID: String? = nil) {
        self.customerID = customerID
        self.variationID = variationID
    }
}
