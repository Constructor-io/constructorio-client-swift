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
    var itemID: String
    var itemName: String?
    var variationID: String?
    var slCampaignID: String?
    var slCampaignOwner: String?

    public init(itemID: String, itemName: String? = nil, variationID: String? = nil,
                slCampaignID: String? = nil, slCampaignOwner: String? = nil) {
        self.itemID = itemID
        self.itemName = itemName
        self.variationID = variationID
        self.slCampaignID = slCampaignID
        self.slCampaignOwner = slCampaignOwner
    }
}
