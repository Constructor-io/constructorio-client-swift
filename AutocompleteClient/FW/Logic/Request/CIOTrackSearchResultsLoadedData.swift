//
//  CIOTrackSearchResultsLoadedData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track search results loaded
 */
struct CIOTrackSearchResultsLoadedData: CIORequestData {
    let searchTerm: String
    let resultCount: Int
    let resultID: String?
    let url: String
    let customerIDs: [String]?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackSearchResultsLoaded.format, baseURL)
    }

    init(searchTerm: String, resultCount: Int, resultID: String? = nil, url: String = "Not Available", customerIDs: [String]? = nil, analyticsTags: [String: String]? = nil) {
        self.searchTerm = searchTerm
        self.resultCount = resultCount
        self.resultID = resultID
        self.url = url
        self.customerIDs = customerIDs
        self.analyticsTags = analyticsTags
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "search_term": self.searchTerm,
            "result_count": Int(self.resultCount),
            "url": self.url
        ] as [String: Any]

        if let loadedCustomerIDs = self.customerIDs {
            let items = loadedCustomerIDs.map { ["item_id": $0] }
            dict["items"] = items
        }

        if self.resultID != nil {
            dict["result_id"] = self.resultID
        }

        if (self.analyticsTags != nil) {
            dict["analytics_tags"] = self.analyticsTags
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
