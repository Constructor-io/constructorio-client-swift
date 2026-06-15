//
//  CIOResultItem.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a result item for viewable impression tracking
 */
public struct CIOResultItem {
    let itemID: String
    let itemName: String?
    let variationID: String?
    let slCampaignID: String?
    let slCampaignOwner: String?

    public init(itemID: String, itemName: String? = nil, variationID: String? = nil,
                slCampaignID: String? = nil, slCampaignOwner: String? = nil) {
        self.itemID = itemID
        self.itemName = itemName
        self.variationID = variationID
        self.slCampaignID = slCampaignID
        self.slCampaignOwner = slCampaignOwner
    }
}
