//
//  CIOAutocompleteClickTracker.swift
//  Constructor.io
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
public struct CIOAutocompleteClickTrackData: HasSectionName {

    public let searchTerm: String
    public let clickedItemName: String
    public var sectionName: String?
    
    public let group: CIOGroup?

    public init(searchTerm: String, clickedItemName: String, sectionName: String? = nil, group: CIOGroup? = nil) {
        self.searchTerm = searchTerm
        self.clickedItemName = clickedItemName
        self.sectionName = sectionName
        self.group = group
    }

}
