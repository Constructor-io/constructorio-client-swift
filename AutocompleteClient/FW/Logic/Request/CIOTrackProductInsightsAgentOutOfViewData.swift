//
//  CIOTrackProductInsightsAgentOutOfViewData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a Product Insights Agent out of view
 */
struct CIOTrackProductInsightsAgentOutOfViewData: CIORequestData {

    let itemID: String
    let itemName: String?
    let variationID: String?
    let threadID: String?
    let sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackProductInsightsAgentOutOfView.format, baseURL)
    }

    init(itemID: String, itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.itemName = itemName
        self.variationID = variationID
        self.threadID = threadID
        self.sectionName = sectionName
        self.analyticsTags = analyticsTags
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.sectionName)
    }

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "item_id": self.itemID
        ] as [String: Any]

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
