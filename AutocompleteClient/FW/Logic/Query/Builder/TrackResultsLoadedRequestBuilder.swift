//
//  TrackResultsLoadedRequestBuilder.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class TrackSearchResultsLoadedRequestBuilder: RequestBuilder {

    init(tracker: CIOSearchResultsLoadedTrackData, autocompleteKey: String) {
        super.init(autocompleteKey: autocompleteKey)
        
        self.set(searchTerm: tracker.searchTerm)
        self.set(numResults: tracker.resultCount)
        self.set(action: Constants.TrackAutocomplete.searchResults)
    }
    
    override func getURLString() -> String {
        return String(format: Constants.Track.trackBehaviorStringFormat, Constants.Track.baseURLString, Constants.TrackSearch.pathBehavior)
    }
}

extension RequestBuilder{
    func set(action: String){
        self.queryItems.add(URLQueryItem(name: Constants.TrackAutocomplete.action, value: Constants.TrackAutocomplete.searchResults))
    }
}
