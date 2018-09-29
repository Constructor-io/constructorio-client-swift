//
//  CIOTrackSearchSubmitData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a search submission
 */
public struct CIOTrackSearchSubmitData: CIORequestData {
    
    public let searchTerm: String
    public let originalQuery: String
    public let group: CIOGroup?
    
    public var url: String{
        return String(format: Constants.Track.trackStringFormat, Constants.Track.baseURLString, Constants.TrackAutocomplete.pathString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, Constants.TrackAutocompleteSelect.searchType)
    }
    
    public init(searchTerm: String, originalQuery: String, group: CIOGroup? = nil) {
        self.searchTerm = searchTerm
        self.originalQuery = originalQuery
        self.group = group
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(originalQuery: self.originalQuery)
        if let group = self.group{
            requestBuilder.set(groupName: group.displayName)
            requestBuilder.set(groupID: group.groupID)
        }
    }
}
