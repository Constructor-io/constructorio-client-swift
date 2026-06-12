//
//  CIOTrackRecommendationResultsViewData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that should be set in order to track recommendation results view
 */
struct CIOTrackRecommendationResultsViewData: CIORequestData {

    let podID: String
    let url: String
    let numResultsViewed: Int?
    let resultPage: Int?
    let resultCount: Int?
    let sectionName: String?
    let resultID: String?
    let customerIDs: [String]?
    let analyticsTags: [String: String]?
    let seedItemIDs: [String]?
    let items: [CIOItem]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackRecommendationResultsView.format, baseURL)
    }

    init(podID: String, numResultsViewed: Int? = nil, customerIDs: [String]? = nil, resultPage: Int? = nil, resultCount: Int? = nil, sectionName: String? = nil, resultID: String? = nil, url: String = "Not Available", analyticsTags: [String: String]? = nil, seedItemIDs: [String]? = nil, items: [CIOItem]? = nil) {
        self.podID = podID
        self.url = url
        self.numResultsViewed = numResultsViewed
        self.resultPage = resultPage
        self.resultCount = resultCount
        self.sectionName = sectionName
        self.resultID = resultID
        self.customerIDs = customerIDs
        self.analyticsTags = analyticsTags
        self.seedItemIDs = seedItemIDs
        self.items = items
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "pod_id": self.podID,
            "url": self.url
        ] as [String: Any]

        if self.numResultsViewed != nil {
            dict["num_results_viewed"] = self.numResultsViewed
        }
        if self.resultPage != nil {
            dict["result_page"] = self.resultPage
        }
        if self.resultCount != nil {
            dict["result_count"] = self.resultCount
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }
        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }
        if let providedItems = self.items {
            let itemsArray = providedItems.map { item -> [String: String] in
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
        } else if let loadedCustomerIDs = self.customerIDs {
            let itemsArray = loadedCustomerIDs.map { ["item_id": $0] }
            dict["items"] = itemsArray
        }
        if (self.analyticsTags != nil) {
            dict["analytics_tags"] = self.analyticsTags
        }
        if let seedItemIDs = self.seedItemIDs, !seedItemIDs.isEmpty {
            dict["seed_item_ids"] = seedItemIDs
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
