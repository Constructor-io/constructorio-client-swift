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
    var itemName: String?
    var variationID: String?
    var quantity: Int?
    var slCampaignID: String?
    var slCampaignOwner: String?

    public init(customerID: String, itemName: String? = nil, variationID: String? = nil, quantity: Int? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil) {
        self.customerID = customerID
        self.itemName = itemName
        self.variationID = variationID
        self.quantity = quantity
        self.slCampaignID = slCampaignID
        self.slCampaignOwner = slCampaignOwner
    }

    // Builds the item object sent by trackResultsImpressionView and trackProductInsightsAgentAnswerView.
    // Other events send different item shapes (purchase repeats each item `quantity` times and sends only item_id/variation_id,
    // and ASA/search/browse/recommendations omit item_name)
    func toImpressionDictionary() -> [String: String] {
        var dict = ["item_id": self.customerID]
        if let itemName = self.itemName {
            dict["item_name"] = itemName
        }
        if let variationID = self.variationID {
            dict["variation_id"] = variationID
        }
        if let campaignID = self.slCampaignID {
            dict["sl_campaign_id"] = campaignID
        }
        if let campaignOwner = self.slCampaignOwner {
            dict["sl_campaign_owner"] = campaignOwner
        }
        return dict
    }
}
