//
//  CIOTrackAutocompleteSelectData.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a click on an autocomplete result.
 
 `sectionName` is an optional parameter.
 - If specified, it will report the autocomplete click as a *select* type and should be used for all types of item clicks, which simply tracks a user selection on an autocomplete item.
 - Otherwise, it will report the autocomplete click as a *search* type, typically used when the clicked item is a search suggestion for tracking what users search (in addition to the *select* type).
 */
public struct CIOTrackAutocompleteSelectData: CIORequestData {
    
    public let searchTerm: String
    public let originalQuery: String
    public let group: CIOGroup?
    public let sectionName: String

    public var url: String{
        return String(format: Constants.TrackAutocompleteSelect.format, Constants.Track.baseURLString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }
    
    public init(searchTerm: String, originalQuery: String, sectionName: String, group: CIOGroup? = nil) {
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
