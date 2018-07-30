//
//  InputFocusRequestBuilder.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class TrackInputFocusRequestBuilder: RequestBuilder {

    init(tracker: CIOInputFocusTrackData, autocompleteKey: String) {
        super.init(autocompleteKey: autocompleteKey)
        
        if let term = tracker.searchTerm{
            self.set(searchTerm: term)
        }
        
        self.set(action: Constants.TrackAutocomplete.actionFocus)
    }
    
    override func getURLString() -> String {
        return String(format: Constants.Track.trackBehaviorStringFormat, Constants.Track.baseURLString, Constants.TrackSearch.pathBehavior)
    }
}
