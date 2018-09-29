//
//  CIOTrackAutocompleteSelectData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track selecting an autocomplete result.
*/
public struct CIOTrackAutocompleteSelectData: CIORequestData, HasSectionName {
    
    public let searchTerm: String
    public let originalQuery: String
    public let group: CIOGroup?
    public var sectionName: String?

    public var url: String{
        return String(format: Constants.Track.trackStringFormat, Constants.Track.baseURLString, Constants.TrackAutocomplete.pathString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, Constants.TrackAutocompleteSelect.selectType)
    }
    
    public init(searchTerm: String, originalQuery: String, sectionName: String? = nil, group: CIOGroup? = nil) {
        self.searchTerm = searchTerm
        self.originalQuery = originalQuery
        self.group = group
        self.sectionName = sectionName
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(originalQuery: self.originalQuery)
        if let group = self.group{
            requestBuilder.set(groupName: group.displayName)
            requestBuilder.set(groupID: group.groupID)
        }
        requestBuilder.set(autocompleteSection: self.sectionName)
        requestBuilder.addTriggerQueryItem()
    }
}
