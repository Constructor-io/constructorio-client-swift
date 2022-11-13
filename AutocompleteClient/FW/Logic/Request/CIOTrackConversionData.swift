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
    let conversionType: String?
    let variationID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackConversion.format, baseURL)
    }

    init(searchTerm: String, itemName: String, customerID: String, sectionName: String? = nil, revenue: Double? = nil, conversionType: String? = nil, variationID: String? = nil) {
        self.searchTerm = searchTerm
        self.itemName = itemName
        self.customerID = customerID
        self.sectionName = sectionName
        self.revenue = revenue
        self.conversionType = conversionType
        self.variationID = variationID
    }

    func httpMethod() -> String {
        return "POST"
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.sectionName)
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "search_term": self.searchTerm,
            "item_id": self.customerID,
            "item_name": self.itemName
        ] as [String: Any]

        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.revenue != nil {
            dict["revenue"] = NSString(format: "%.2f", self.revenue!)
        }

        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }

        if self.conversionType != nil {
            dict["type"] = self.conversionType
        }
        
        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
