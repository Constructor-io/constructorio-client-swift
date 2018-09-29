//
//  CIOTracker.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public protocol CIOTracker: class{
    
    func trackInputFocus(for tracker: CIOTrackInputFocusData, completionHandler: TrackingCompletionHandler?)

    func trackAutocompleteSelect(for tracker: CIOTrackAutocompleteSelectData, completionHandler: TrackingCompletionHandler?)
    
    func trackSearchSubmit(for tracker: CIOTrackSearchSubmitData, completionHandler: TrackingCompletionHandler?)
    
    func trackSearchResultsLoaded(for tracker: CIOTrackSearchResultsLoadedData, completionHandler: TrackingCompletionHandler?)
    
    func trackSearchResultClick(for tracker: CIOTrackSearchResultClickData, completionHandler: TrackingCompletionHandler?)

    func trackConversion(for tracker: CIOTrackConversionData, completionHandler: TrackingCompletionHandler?)

}
