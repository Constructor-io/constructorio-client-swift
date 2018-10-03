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
public struct CIOTrackConversionData: CIORequestData, HasSectionName {

    public let searchTerm: String
    public let itemID: String?
    public var sectionName: String?
    public let revenue: Int?
    
    public var url: String{
        return String(format: Constants.Track.trackStringFormat, Constants.Track.baseURLString, Constants.TrackAutocomplete.pathString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!, Constants.TrackConversion.type)
    }

    public init(searchTerm: String, itemID: String? = nil, sectionName: String? = nil, revenue: Int? = nil) {
        self.searchTerm = searchTerm
        self.itemID = itemID
        self.sectionName = sectionName
        self.revenue = revenue
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(itemID: self.itemID)
        requestBuilder.set(autocompleteSection: self.sectionName)
        requestBuilder.set(revenue: self.revenue)
    }
}
