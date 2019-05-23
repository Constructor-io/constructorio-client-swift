//
//  CIOTrackSearchResultsLoadedData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track search results loaded
 */
struct CIOTrackSearchResultsLoadedData: CIORequestData {
    let searchTerm: String
    let resultCount: Int

    var url: String {
        return String(format: Constants.TrackSearchResultsLoaded.format, Constants.Track.baseURLString)
    }

    init(searchTerm: String, resultCount: Int) {
        self.searchTerm = searchTerm
        self.resultCount = resultCount
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(searchTerm: self.searchTerm)
        requestBuilder.set(numResults: self.resultCount)
    }

}
