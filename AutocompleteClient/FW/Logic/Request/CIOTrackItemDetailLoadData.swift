//
//  CIOTrackItemDetailLoadData.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set set in order to track item detail load
 */
struct CIOTrackItemDetailLoadData: CIORequestData {

    let itemName: String
    let customerID: String
    let sectionName: String?
    let variationID: String?
    let pageUrl: String?
    

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackItemDetailLoad.format, baseURL)
    }

    init(itemName: String, customerID: String,variationID: String? = nil, sectionName: String? = nil, url: String? = nil) {
        self.customerID = customerID
        self.sectionName = sectionName
        self.variationID = variationID
        self.itemName = itemName
        self.pageUrl = url
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "item_name": self.itemName,
            "item_id": self.customerID,
            "url": self.pageUrl ?? "unknown"
        ] as [String: Any]

        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
