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

    var customerIDs: [String]
    let revenue: Double?
    var sectionName: String?
    var orderID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackPurchase.format, baseURL)
    }

    init(customerIDs: [String], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil) {
        
        if (customerIDs.count > 100) {
            self.customerIDs = Array(customerIDs[0 ..< 100])
        } else {
            self.customerIDs = customerIDs
        }
        self.sectionName = sectionName
        self.revenue = revenue
        self.orderID = orderID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.sectionName)
    }

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        let items = self.customerIDs.map { ["item_id": $0] }
        var dict = ["items": items] as [String: Any]

        if self.orderID != nil {
            dict["order_id"] = self.orderID
        }

        if self.revenue != nil {
            dict["revenue"] = self.revenue
        }

        dict.merge(baseParams) { current, _ in current }
        dict["section"] = nil

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
