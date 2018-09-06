//
//  CIOTrackSearchResultsLoadedData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOTrackSearchResultsLoadedData: CIORequestData{
    let searchTerm: String
    let resultCount: Int
    
    public var url: String {
        return String(format: Constants.Track.trackBehaviorStringFormat, Constants.Track.baseURLString, Constants.TrackSearch.pathBehavior)
    }
    
    public init(searchTerm: String, resultCount: Int){
        self.searchTerm = searchTerm
        self.resultCount = resultCount
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(searchTerm: self.searchTerm)
        requestBuilder.set(numResults: self.resultCount)
        requestBuilder.set(action: Constants.TrackAutocomplete.actionSearchResults)
    }
    
}
