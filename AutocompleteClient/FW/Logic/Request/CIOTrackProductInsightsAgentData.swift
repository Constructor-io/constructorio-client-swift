//
//  CIOTrackProductInsightsAgentData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Protocol for the fields shared by every Product Insights Agent tracking event
 */
protocol CIOTrackProductInsightsAgentData: CIORequestData {

    var itemName: String? { get }
    var variationID: String? { get }
    var threadID: String? { get }
    var analyticsTags: [String: String]? { get }
}

extension CIOTrackProductInsightsAgentData {

    // Adds the optional fields shared by every Product Insights Agent event to the request body
    func addCommonFields(to dict: inout [String: Any]) {
        if let itemName = self.itemName {
            dict["item_name"] = itemName
        }
        if let variationID = self.variationID {
            dict["variation_id"] = variationID
        }
        if let threadID = self.threadID {
            dict["thread_id"] = threadID
        }
        if let analyticsTags = self.analyticsTags {
            dict["analytics_tags"] = analyticsTags
        }
    }
}
