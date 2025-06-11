//
//  CIOTrackBrowseResultsLoadedData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track browse results loaded
 */
struct CIOTrackBrowseResultsLoadedData: CIORequestData {
    let filterName: String
    let filterValue: String
    let resultCount: Int
    let resultID: String?
    let url: String
    let customerIDs: [String]?
    let items: [CIOItem]?
    let slAdvertiser: String?
    let slCampaignID: String?
    let slCampaignOwner: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackBrowseResultsLoaded.format, baseURL)
    }

    init(filterName: String, filterValue: String, resultCount: Int, resultID: String? = nil, url: String = "Not Available", customerIDs: [String]? = nil, items: [CIOItem]? = nil, slAdvertiser: String? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil, analyticsTags: [String: String]? = nil) {
        self.filterName = filterName
        self.filterValue = filterValue
        self.resultCount = resultCount
        self.resultID = resultID
        self.url = url
        self.customerIDs = customerIDs
        self.items = items
        self.slAdvertiser = slAdvertiser
        self.slCampaignID = slCampaignID
        self.slCampaignOwner = slCampaignOwner
        self.analyticsTags = analyticsTags
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "filter_name": self.filterName,
            "filter_value": self.filterValue,
            "result_count": Int(self.resultCount),
            "url": self.url
        ] as [String: Any]

        if let providedItems = self.items {
            let itemsArray = providedItems.map { item -> [String: String] in
                var obj: [String: String] = ["item_id": item.customerID]
                if let variationID = item.variationID {
                    obj["variation_id"] = variationID
                }
                return obj
            }
            dict["items"] = itemsArray
        } else if let loadedCustomerIDs = self.customerIDs {
            let itemsArray = loadedCustomerIDs.map { ["item_id": $0] }
            dict["items"] = itemsArray
        }

        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }

        if let advertiser = self.slAdvertiser {
            dict["sl_advertiser"] = advertiser
        }
        if let campaignID = self.slCampaignID {
            dict["sl_campaign_id"] = campaignID
        }
        if let campaignOwner = self.slCampaignOwner {
            dict["sl_campaign_owner"] = campaignOwner
        }

        if (self.analyticsTags != nil) {
            dict["analytics_tags"] = self.analyticsTags
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
