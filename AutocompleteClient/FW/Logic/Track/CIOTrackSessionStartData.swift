//
//  CIOTrackSessionStartData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIOTrackSessionStartData: CIORequestData {
    let session: Int
    
    public var url: String {
        return String(format: Constants.Track.trackBehaviorStringFormat, Constants.Track.baseURLString, Constants.TrackSearch.pathBehavior)
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder){
        requestBuilder.set(action: Constants.TrackAutocomplete.actionSessionStart)
    }
}
