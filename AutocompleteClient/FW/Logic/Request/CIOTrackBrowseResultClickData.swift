//
//  CIOTrackBrowseResultClickData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track browse result click
 */
struct CIOTrackBrowseResultClickData: CIORequestData {

    let filterName: String
    let filterValue: String
    let customerID: String
    let resultPositionOnPage: Int?
    var sectionName: String?
    let resultID: String?
    let variationID: String?
    let slCampaignID: String?
    let slCampaignOwner: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackBrowseResultClick.format, baseURL)
    }

    init(filterName: String, filterValue: String, customerID: String, resultPositionOnPage: Int?, sectionName: String? = nil, resultID: String? = nil, variationID: String? = nil, slCampaignID: String? = nil, slCampaignOwner: String? = nil, analyticsTags: [String: String]? = nil) {
        self.filterName = filterName
        self.filterValue = filterValue
        self.customerID = customerID
        self.resultPositionOnPage = resultPositionOnPage
        self.sectionName = sectionName
        self.resultID = resultID
        self.variationID = variationID
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
            "item_id": self.customerID
        ] as [String: Any]

        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.resultPositionOnPage != nil {
            dict["result_position_on_page"] = Int(self.resultPositionOnPage!)
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }
        if self.resultID != nil {
            dict["result_id"] = self.resultID
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
