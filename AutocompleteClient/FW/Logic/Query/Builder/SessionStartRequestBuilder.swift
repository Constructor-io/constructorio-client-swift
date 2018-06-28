//
//  SessionStartRequestBuilder.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

class SessionStartRequestBuilder: RequestBuilder {

    init(autocompleteKey: String){
        super.init(autocompleteKey: autocompleteKey)
        self.set(action: Constants.TrackAutocomplete.actionSessionStart)
    }
    
    override func getURLString() -> String {
        return String(format: Constants.Track.trackBehaviorStringFormat, Constants.Track.baseURLString, Constants.TrackSearch.pathBehavior)
    }
}
