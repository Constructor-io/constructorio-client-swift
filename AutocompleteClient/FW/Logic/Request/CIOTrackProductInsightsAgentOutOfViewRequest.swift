//
//  CIOTrackProductInsightsAgentOutOfViewRequest.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that can be passed to constructorIO.trackProductInsightsAgentOutOfView() function.
 */
public struct CIOTrackProductInsightsAgentOutOfViewRequest {

    /**
     The ID of the product whose page the Product Insights Agent is on
     */
    public let itemID: String

    /**
     The name of the product whose page the Product Insights Agent is on
     */
    public let itemName: String?

    /**
     The variation ID of the product whose page the Product Insights Agent is on
     */
    public let variationID: String?

    /**
     The ID used to group events within a single conversation thread
     */
    public let threadID: String?

    /**
     The name of the section the item belongs to (defaults to the configured default section, or "Products")
     */
    public let sectionName: String?

    /**
     Additional custom analytics tags to be sent with the event. Merged with the default analytics tags
     */
    public let analyticsTags: [String: String]?

    /**
     Create a Product Insights Agent out of view request

     - Parameters:
        - itemID: The ID of the product whose page the Product Insights Agent is on
        - itemName: The name of the product whose page the Product Insights Agent is on
        - variationID: The variation ID of the product whose page the Product Insights Agent is on
        - threadID: The ID used to group events within a single conversation thread
        - sectionName: The name of the section the item belongs to (defaults to the configured default section, or "Products")
        - analyticsTags: Additional custom analytics tags to be sent with the event. Merged with the default analytics tags
     */
    public init(itemID: String, itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.itemName = itemName
        self.variationID = variationID
        self.threadID = threadID
        self.sectionName = sectionName
        self.analyticsTags = analyticsTags
    }
}
