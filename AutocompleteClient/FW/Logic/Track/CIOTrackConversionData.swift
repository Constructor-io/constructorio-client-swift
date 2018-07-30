//
//  CIOTrackConversionData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track a conversion for an autocomplete.
 */
public struct CIOTrackConversionData: HasSectionName {

    public let searchTerm: String
    public let itemID: String?
    public var sectionName: String?
    public let revenue: Int?

    public init(searchTerm: String, itemID: String? = nil, sectionName: String? = nil, revenue: Int? = nil) {
        self.searchTerm = searchTerm
        self.itemID = itemID
        self.sectionName = sectionName
        self.revenue = revenue
    }
}
