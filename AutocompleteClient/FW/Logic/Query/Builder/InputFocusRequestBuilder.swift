//
//  InputFocusRequestBuilder.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 6/28/18.
//  Copyright © 2018 xd. All rights reserved.
//

import UIKit

class InputFocusRequestBuilder: RequestBuilder {

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
