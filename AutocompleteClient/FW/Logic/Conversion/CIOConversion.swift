//
//  CIOConversion.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

/**
 Conversion tracking class. Tracking functions are implemented in the ConstructorIO class but they require specifying exactly what data is being sent. CIOConversion uses default values for most parameters except ones that need to be specified by the user (convention over configuration).
 */
public class CIOConversion: NSObject {

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
        let trackData = CIOConversionTrackData(searchTerm: "TERM_UNKNOWN", itemName: nil, itemID: itemID, sectionName: nil, revenue: revenue)
        self.tracker?.trackConversion(for: trackData, completionHandler: completionHandler)
    }
    
}
