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

    var customerIDs: [String]?
    let revenue: Double?
    var sectionName: String?
    var orderID: String?
    var items: [CIOItem]?

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

    
    init(items: [CIOItem], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil) {
        
        if (items.count > 100) {
            self.items = Array(items[0 ..< 100])
        } else {
            self.items = items
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
        var dict = [String: Any]()

        if let purchasedCustomerIDs = self.customerIDs {
            let items = purchasedCustomerIDs.map { ["item_id": $0] }
            dict["items"] = items
        }

        if let purchasedItems = self.items {
            var items = [[String: String]]()

            for item in purchasedItems {
                var itemToAppend = ["item_id": item.customerID]

                if (item.variationID != nil) {
                    itemToAppend["variation_id"] = item.variationID
                }

                items.append(itemToAppend)
            }
            dict = ["items": items]
        }

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
