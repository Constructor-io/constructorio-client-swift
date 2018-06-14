//
//  CIOConversionTracker.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track a conversion for an autocomplete.
 */
public struct CIOConversionTrackData {

    public let searchTerm: String
    public let itemName: String?
    public let itemID: String?
    public let sectionName: String?
    public let revenue: Int?

    public init(searchTerm: String, itemName: String? = nil, itemID: String? = nil, sectionName: String? = nil, revenue: Int? = nil) {
        self.searchTerm = searchTerm
        self.itemName = itemName
        self.itemID = itemID
        self.sectionName = sectionName
        self.revenue = revenue
    }
}
