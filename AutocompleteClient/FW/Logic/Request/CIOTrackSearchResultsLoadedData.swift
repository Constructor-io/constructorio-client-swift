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
public struct CIOTrackSearchResultsLoadedData: CIORequestData {
    let searchTerm: String
    let resultCount: Int

    public var url: String {
        return String(format: Constants.TrackSearchResultsLoaded.format, Constants.Track.baseURLString)
    }

    public init(searchTerm: String, resultCount: Int) {
        self.searchTerm = searchTerm
        self.resultCount = resultCount
    }

    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(searchTerm: self.searchTerm)
        requestBuilder.set(numResults: self.resultCount)
    }

}
