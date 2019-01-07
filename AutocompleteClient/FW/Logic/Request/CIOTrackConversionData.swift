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
public struct CIOTrackConversionData: CIORequestData {

    public let searchTerm: String
    public let itemName: String
    public let customerID: String
    public var sectionName: String?
    public let revenue: Double?

    public var url: String {
        return String(format: Constants.TrackConversion.format, Constants.Track.baseURLString, self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }

    public init(searchTerm: String, itemName: String, customerID: String, sectionName: String? = nil, revenue: Double? = nil) {
        self.searchTerm = searchTerm
        self.itemName = itemName
        self.customerID = customerID
        self.sectionName = sectionName
        self.revenue = revenue
    }

    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(name: self.itemName)
        requestBuilder.set(customerID: self.customerID)
        requestBuilder.set(autocompleteSection: self.sectionName)
        requestBuilder.set(revenue: self.revenue)
    }
}
