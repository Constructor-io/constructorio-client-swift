//
//  CIOTracker.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public protocol CIOTracker: class{

    func trackAutocompleteClick(for tracker: CIOTrackAutocompleteClickData, completionHandler: TrackingCompletionHandler?)
    
    func trackConversion(for tracker: CIOTrackConversionData, completionHandler: TrackingCompletionHandler?)
    
    func trackSearch(for tracker: CIOTrackSearchData, completionHandler: TrackingCompletionHandler?)
    
    func trackSearchResultsLoaded(for tracker: CIOTrackSearchResultsLoadedData, completionHandler: TrackingCompletionHandler?)
}
