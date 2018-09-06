//
//  CIOTracking.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

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
    
    /// Track autocomplete click.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - clickedItemName: Name of the clicked item
    ///   - sectionName: Section name of the item clicked on
    ///   - group: Item group
    ///   - completionHandler: The callback to execute on completion.
    public func trackAutocompleteClick(searchTerm: String, clickedItemName: String, sectionName: String? = nil, group: CIOGroup? = nil, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackAutocompleteClickData(searchTerm: searchTerm, clickedItemName: clickedItemName, sectionName: sectionName, group: group)
        self.tracker?.trackAutocompleteClick(for: data, completionHandler: completionHandler)
    }
    
    /// Track search.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - itemName: Name of the clicked item
    ///   - completionHandler: The callback to execute on completion.
    public func trackSearch(searchTerm: String, itemName: String, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOTrackSearchData(searchTerm: searchTerm, itemName: itemName)
        self.tracker?.trackSearch(for: data, completionHandler: completionHandler)
    }
    
}
