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
    var slCampaignID: String?
    var slCampaignOwner: String?

    public init(customerID: String, variationID: String? = nil, quantity: Int? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil) {
        self.customerID = customerID
        self.variationID = variationID
        self.quantity = quantity
        self.slCampaignID = slCampaignID
        self.slCampaignOwner = slCampaignOwner
    }
}
