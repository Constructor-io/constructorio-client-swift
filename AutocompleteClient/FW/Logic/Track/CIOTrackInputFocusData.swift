//
//  CIOTrackInputFocusData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track search bar focus
 */
public struct CIOTrackInputFocusData: CIORequestData {
    let searchTerm: String?
    
    public var url: String {
        return String(format: Constants.TrackInputFocus.format, Constants.Track.baseURLString)
    }
    
    init(searchTerm: String?) {
        self.searchTerm = searchTerm
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        if let term = self.searchTerm{
            requestBuilder.set(searchTerm: term)
        }
    }
}
