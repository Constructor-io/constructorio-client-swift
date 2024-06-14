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
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackPurchase.format, baseURL)
    }

    init(customerIDs: [String], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil, analyticsTags: [String: String]? = nil) {
        if customerIDs.count > 100 {
            self.customerIDs = Array(customerIDs[0 ..< 100])
        } else {
            self.customerIDs = customerIDs
        }
        self.sectionName = sectionName
        self.revenue = revenue
        self.orderID = orderID
        self.analyticsTags = analyticsTags
    }

    init(items: [CIOItem], sectionName: String? = nil, revenue: Double? = nil, orderID: String? = nil, analyticsTags: [String: String]? = nil) {
        if items.count > 100 {
            self.items = Array(items[0 ..< 100])
        } else {
            self.items = items
        }
        self.sectionName = sectionName
        self.revenue = revenue
        self.orderID = orderID
        self.analyticsTags = analyticsTags
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.sectionName)
    }

    func httpMethod() -> String {
        return "POST"
    }

    func roundTo2dp(num: Double) -> Double {
        return (num * 100).rounded() / 100
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [String: Any]()

        if let purchasedCustomerIDs = self.customerIDs {
            let items = purchasedCustomerIDs.map { ["item_id": $0] }
            dict["items"] = items
        }

        if let purchasedItems = self.items {
            var items = [[String: String]]()
            purchasedItems.forEach { purchaseItem in
                let quantity = purchaseItem.quantity ?? 1
                for _ in 1...quantity {
                    var item = ["item_id": purchaseItem.customerID]
                    if let variation_id = purchaseItem.variationID {
                        item["variation_id"] = variation_id
                    }
                    items.append(item)
                }
            }
            dict["items"] = items
        }

        if self.orderID != nil {
            dict["order_id"] = self.orderID
        }

        if self.revenue != nil {
            dict["revenue"] = self.roundTo2dp(num: self.revenue!)
        }
        
        if (self.analyticsTags != nil) {
            dict["analytics_tags"] = self.analyticsTags
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }
        dict["section"] = nil

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
