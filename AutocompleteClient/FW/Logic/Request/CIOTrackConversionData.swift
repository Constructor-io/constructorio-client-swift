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
struct CIOTrackConversionData: CIORequestData {

    let searchTerm: String
    let itemName: String
    let customerID: String
    var sectionName: String?
    let revenue: Double?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackConversion.format, baseURL,  self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)
    }

    init(searchTerm: String, itemName: String, customerID: String, sectionName: String? = nil, revenue: Double? = nil) {
        self.searchTerm = searchTerm
        self.itemName = itemName
        self.customerID = customerID
        self.sectionName = sectionName
        self.revenue = revenue
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(name: self.itemName)
        requestBuilder.set(customerID: self.customerID)
        requestBuilder.set(autocompleteSection: self.sectionName)
        requestBuilder.set(revenue: self.revenue)
    }
}
