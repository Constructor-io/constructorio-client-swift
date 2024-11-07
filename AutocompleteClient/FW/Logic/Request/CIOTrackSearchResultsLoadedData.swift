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
    let customerIDs: [String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackSearchResultsLoaded.format, baseURL)
    }

    init(searchTerm: String, resultCount: Int, customerIDs: [String]?) {
        self.searchTerm = searchTerm
        self.resultCount = resultCount
        self.customerIDs = customerIDs
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(searchTerm: self.searchTerm)
        requestBuilder.set(numResults: self.resultCount)
        requestBuilder.set(customerIDs: self.customerIDs)
    }

}
