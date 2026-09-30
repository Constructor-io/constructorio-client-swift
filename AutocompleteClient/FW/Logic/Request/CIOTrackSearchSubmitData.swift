//
//  CIOTrackSearchSubmitData.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a search submission
 */
struct CIOTrackSearchSubmitData: CIORequestData {

    let searchTerm: String
    let originalQuery: String
    let group: CIOGroup?
    let analyticsTags: [String: String]?
    let section: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackSearchSubmit.format, baseURL)
    }

    init(searchTerm: String, originalQuery: String, group: CIOGroup? = nil, analyticsTags: [String: String]? = nil, section: String? = nil) {
        self.searchTerm = searchTerm
        self.originalQuery = originalQuery
        self.group = group
        self.analyticsTags = analyticsTags
        self.section = section
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.section)
    }

    func httpMethod() -> String {
        return "POST"
    }

    // The endpoint rejects unknown body properties, so base params are sent only as query items
    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "search_term": self.searchTerm,
            "user_input": self.originalQuery
        ] as [String: Any]

        if let group = self.group {
            dict["filters"] = ["group_id": group.groupID]
        }

        if self.analyticsTags != nil {
            dict["analytics_tags"] = self.analyticsTags
        }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
