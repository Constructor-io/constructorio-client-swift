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
    let userInput: String
    let filters: CIOSearchFilters?
    let analyticsTags: [String: String]?
    let section: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackSearchSubmit.format, baseURL)
    }

    init(searchTerm: String, userInput: String, filters: CIOSearchFilters? = nil, analyticsTags: [String: String]? = nil, section: String? = nil) {
        self.searchTerm = searchTerm
        self.userInput = userInput
        self.filters = filters
        self.analyticsTags = analyticsTags
        self.section = section
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.section)
    }

    func httpMethod() -> String {
        return "POST"
    }

    // The endpoint rejects unknown body properties, so base params are only sent as query items
    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "search_term": self.searchTerm,
            "user_input": self.userInput
        ] as [String: Any]

        if let filters = self.filters {
            dict["filters"] = ["group_id": filters.groupID]
        }

        if let analyticsTags = self.analyticsTags {
            dict["analytics_tags"] = analyticsTags
        }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
