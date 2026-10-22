//
//  CIOTrackProductInsightsAgentData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Protocol for the request data shared by every Product Insights Agent tracking event.
 Conforming types only provide their URL and event-specific body fields.
 */
protocol CIOTrackProductInsightsAgentData: CIORequestData {

    var itemID: String { get }
    var itemName: String? { get }
    var variationID: String? { get }
    var threadID: String? { get }
    var sectionName: String? { get }
    var analyticsTags: [String: String]? { get }

    // The body fields specific to this event, excluding the fields shared by every event
    func eventFields() -> [String: Any]
}

extension CIOTrackProductInsightsAgentData {

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.sectionName)
    }

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = self.eventFields()
        dict["item_id"] = self.itemID

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

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
