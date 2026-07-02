//
//  CIOTrackResultsImpressionViewData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a results impression view event
 */
struct CIOTrackResultsImpressionViewData: CIORequestData {

    let items: [CIOItem]
    let searchTerm: String?
    let filterName: String?
    let filterValue: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackResultsImpressionView.format, baseURL)
    }

    init(items: [CIOItem], searchTerm: String? = nil,
         filterName: String? = nil, filterValue: String? = nil) {
        self.items = items
        self.searchTerm = searchTerm
        self.filterName = filterName
        self.filterValue = filterValue
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        let itemDicts: [[String: Any]] = items.map { item in
            var dict: [String: Any] = ["item_id": item.customerID]
            if let name = item.itemName { dict["item_name"] = name }
            if let vid = item.variationID { dict["variation_id"] = vid }
            if let cid = item.slCampaignID { dict["sl_campaign_id"] = cid }
            if let owner = item.slCampaignOwner { dict["sl_campaign_owner"] = owner }
            return dict
        }

        var dict: [String: Any] = [
            "items": itemDicts,
            "beacon": true
        ]

        if let term = self.searchTerm { dict["search_term"] = term }
        if let fn = self.filterName { dict["filter_name"] = fn }
        if let fv = self.filterValue { dict["filter_value"] = fv }

        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
