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
struct CIOTrackPurchaseData: CIORequestData {

    let customerIDs: [String]
    let revenue: Double?
    var sectionName: String?
    var orderID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackPurchase.format, baseURL)
    }

    init(customerIDs: [String], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil) {
        self.customerIDs = customerIDs
        self.sectionName = sectionName
        self.revenue = revenue
        self.orderID = orderID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(customerIDs: self.customerIDs)
        requestBuilder.set(autocompleteSection: self.sectionName)
        requestBuilder.set(revenue: self.revenue)
        requestBuilder.set(orderID: self.orderID)
    }
}
