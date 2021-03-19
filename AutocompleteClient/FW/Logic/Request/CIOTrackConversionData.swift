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

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackConversion.format, baseURL)
    }

    init(searchTerm: String, itemName: String, customerID: String, sectionName: String? = nil, revenue: Double? = nil, conversionType: String? = nil) {
        self.searchTerm = searchTerm
        self.itemName = itemName
        self.customerID = customerID
        self.sectionName = sectionName
        self.revenue = revenue
        self.conversionType = conversionType
    }

    func httpMethod() -> String {
        return "POST"
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(name: self.itemName)
        requestBuilder.set(customerID: self.customerID)
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "search_term": self.searchTerm,
            "item_id": self.customerID,
        ] as [String: Any]

        if self.revenue != nil {
            dict["revenue"] = NSString(format: "%.2f", self.revenue!)
        }

        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }

        if self.conversionType != nil {
            dict["type"] = self.conversionType
        }

        dict.merge(baseParams) { current, _ in current }

        // Remove name, term, and customer from dict as having them in the POST body throws an error
        dict.removeValue(forKey: "name")
        dict.removeValue(forKey: "customer_id")

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
