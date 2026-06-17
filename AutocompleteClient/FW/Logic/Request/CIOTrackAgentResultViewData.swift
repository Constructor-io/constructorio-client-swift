//
//  CIOTrackAgentResultViewData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track an agent result view
 */
struct CIOTrackAgentResultViewData: CIORequestData {

    let intent: String
    let searchResultID: String
    let numResultsViewed: Int
    let items: [CIOItem]?
    var sectionName: String?
    let intentResultID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackAgentResultView.format, baseURL)
    }

    init(intent: String, searchResultID: String, numResultsViewed: Int, items: [CIOItem]? = nil, sectionName: String? = nil, intentResultID: String? = nil) {
        self.intent = intent
        self.searchResultID = searchResultID
        self.numResultsViewed = numResultsViewed
        self.items = items
        self.sectionName = sectionName
        self.intentResultID = intentResultID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "intent": self.intent,
            "search_result_id": self.searchResultID,
            "num_results_viewed": Int(self.numResultsViewed)
        ] as [String: Any]

        if let providedItems = self.items {
            let itemsArray = providedItems.prefix(100).map { item -> [String: String] in
                var obj: [String: String] = ["item_id": item.customerID]
                if let variationID = item.variationID {
                    obj["variation_id"] = variationID
                }
                if let campaignID = item.slCampaignID {
                    obj["sl_campaign_id"] = campaignID
                }
                if let campaignOwner = item.slCampaignOwner {
                    obj["sl_campaign_owner"] = campaignOwner
                }
                return obj
            }
            dict["items"] = itemsArray
        }

        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }
        if self.intentResultID != nil {
            dict["intent_result_id"] = self.intentResultID
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
