//
//  CIOTrackPurchaseData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track a purchase for an item.
 */
public struct CIOTrackPurchaseData: CIORequestData {

    public let customerIDs: [String]
    public let revenue: Double?
    public var sectionName: String?

    public var url: String {
        return String(format: Constants.TrackPurchase.format, Constants.Track.baseURLString)
    }

    public init(customerIDs: [String], sectionName: String? = nil, revenue: Double? = nil) {
        self.customerIDs = customerIDs
        self.sectionName = sectionName
        self.revenue = revenue
    }

    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(customerIDs: self.customerIDs)
        requestBuilder.set(autocompleteSection: self.sectionName)
        requestBuilder.set(revenue: self.revenue)
    }
}
