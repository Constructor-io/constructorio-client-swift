//
//  CIOTrackProductInsightsAgentResultClickRequest.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that can be passed to constructorIO.trackProductInsightsAgentResultClick() function.
 */
public struct CIOTrackProductInsightsAgentResultClickRequest {

    /**
     The ID of the clicked recommended product
     */
    public let itemID: String

    /**
     The question that produced the answer containing the clicked recommendation
     */
    public let question: String

    /**
     The ID of the product whose page the Product Insights Agent is on
     */
    public let seedItemID: String

    /**
     The position of the clicked item in the list of recommendations
     */
    public let position: Int?

    /**
     The name of the product whose page the Product Insights Agent is on
     */
    public let seedItemName: String?

    /**
     The variation ID of the product whose page the Product Insights Agent is on
     */
    public let seedVariationID: String?

    /**
     The ID of the answer result returned by the Product Insights Agent
     */
    public let qnaResultID: String?

    /**
     The name of the clicked recommended product
     */
    public let itemName: String?

    /**
     The variation ID of the clicked recommended product
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
     Create a Product Insights Agent result click request

     - Parameters:
        - itemID: The ID of the clicked recommended product
        - question: The question that produced the answer containing the clicked recommendation
        - seedItemID: The ID of the product whose page the Product Insights Agent is on
        - position: The position of the clicked item in the list of recommendations
        - seedItemName: The name of the product whose page the Product Insights Agent is on
        - seedVariationID: The variation ID of the product whose page the Product Insights Agent is on
        - qnaResultID: The ID of the answer result returned by the Product Insights Agent
        - itemName: The name of the clicked recommended product
        - variationID: The variation ID of the clicked recommended product
        - threadID: The ID used to group events within a single conversation thread
        - sectionName: The name of the section the item belongs to (defaults to the configured default section, or "Products")
        - analyticsTags: Additional custom analytics tags to be sent with the event. Merged with the default analytics tags
     */
    public init(itemID: String, question: String, seedItemID: String, position: Int? = nil, seedItemName: String? = nil, seedVariationID: String? = nil, qnaResultID: String? = nil, itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.question = question
        self.seedItemID = seedItemID
        self.position = position
        self.seedItemName = seedItemName
        self.seedVariationID = seedVariationID
        self.qnaResultID = qnaResultID
        self.itemName = itemName
        self.variationID = variationID
        self.threadID = threadID
        self.sectionName = sectionName
        self.analyticsTags = analyticsTags
    }
}
