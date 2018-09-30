//
//  CIOTrackConversionData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track a conversion for an item.
 */
public struct CIOTrackConversionData: CIORequestData, HasDefaultSectionName {

    public let searchTerm: String
    public let itemID: String
    public var sectionName: String?
    public let revenue: Int?
    
    public var url: String{
        return String(format: Constants.TrackConversion.format, Constants.Track.baseURLString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }

    public init(searchTerm: String, itemID: String, sectionName: String? = nil, revenue: Int? = nil) {
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
