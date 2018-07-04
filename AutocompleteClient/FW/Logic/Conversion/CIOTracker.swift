//
//  CIOTracker.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import UIKit

public protocol CIOTracker: class{

    func trackAutocompleteClick(for tracker: CIOAutocompleteClickTrackData, completionHandler: TrackingCompletionHandler?)
    
    func trackConversion(for tracker: CIOConversionTrackData, completionHandler: TrackingCompletionHandler?)
    
    func trackSearch(for tracker: CIOSearchTrackData, completionHandler: TrackingCompletionHandler?)
}
