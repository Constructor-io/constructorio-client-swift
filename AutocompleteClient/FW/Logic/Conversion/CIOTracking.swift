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
    ///   - completionHandler: The callback to execute on completion.
    public func trackConversion(itemID: String, revenue: Int?, completionHandler: TrackingCompletionHandler? = nil){
        let trackData = CIOConversionTrackData(searchTerm: "TERM_UNKNOWN", itemID: itemID, sectionName: nil, revenue: revenue)
        self.tracker?.trackConversion(for: trackData, completionHandler: completionHandler)
    }
    
    /// Track results loaded.
    ///
    /// - Parameters:
    ///   - searchTerm: Search term that the user searched for
    ///   - resultCount: Number of results loaded
    ///   - completionHandler: The callback to execute on completion.
    public func trackResultsLoaded(searchTerm: String, resultCount: Int, completionHandler: TrackingCompletionHandler? = nil){
        let data = CIOSearchResultsLoadedTrackData(searchTerm: searchTerm, resultCount: resultCount )
        self.tracker?.trackSearchResultsLoaded(for: data, completionHandler: completionHandler)
    }
    
}
