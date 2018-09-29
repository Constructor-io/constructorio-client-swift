//
//  CIOTracking.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Tracking class. Tracking functions are implemented in the ConstructorIO class but they require specifying exactly what data is being sent. CIOTracking uses default values for most parameters except ones that need to be specified by the user (convention over configuration).
 */
public class CIOTracking: NSObject {

    private weak var tracker: CIOTracker?
    
    init(tracker: CIOTracker){
        self.tracker = tracker
    }
    
    /// Track a conversion.
    ///
    /// - Parameters:
    ///   - itemID: ID of an item.
    ///   - revenue: Revenue of an item.
    ///   - searchTerm: Search term that the user searched for. If nil is passed, 'TERM_UNKNOWN' will be sent to the server.
    ///   - completionHandler: The callback to execute on completion.
    public func trackConversion(itemID: String, revenue: Int?, searchTerm: String?, completionHandler: TrackingCompletionHandler? = nil){
        let trackData = CIOTrackConversionData(searchTerm: (searchTerm ?? "TERM_UNKNOWN"), itemID: itemID, sectionName: nil, revenue: revenue)
        self.tracker?.trackConversion(for: trackData, completionHandler: completionHandler)
    }
    
    /// Track search results loaded.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - resultCount: Number of results loaded
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchResultsLoaded(searchTerm: String, resultCount: Int, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount )
        self.tracker?.trackSearchResultsLoaded(for: data, completionHandler: completionHandler)
    }
    
    /// Track autocomplete select.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user selected
    ///   - originalQuery: The original query that the user searched for
    ///   - sectionName The name of the autocomplete section the term came from
    ///   - group: Item group
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteSelect(searchTerm: String, originalQuery: String, sectionName: String, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackAutocompleteSelectData(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group)
        self.tracker?.trackAutocompleteSelect(for: data, completionHandler: completionHandler)
    }
    
    /// Track search submit
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - originalQuery: The original query that the user search for
    ///   - group: Item group
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearchSubmit(searchTerm: String, originalQuery: String, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group)
        self.tracker?.trackSearchSubmit(for: data, completionHandler: completionHandler)
    }
    
}
