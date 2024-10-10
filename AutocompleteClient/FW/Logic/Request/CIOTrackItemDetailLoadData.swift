//
//  CIOTrackItemDetailLoadData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
    let url: String
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackItemDetailLoad.format, baseURL)
    }

    init(itemName: String, customerID: String,variationID: String? = nil, sectionName: String? = nil, url: String = "Not Available", analyticsTags: [String: String]? = nil) {
        self.customerID = customerID
        self.sectionName = sectionName
        self.variationID = variationID
        self.itemName = itemName
        self.url = url
        self.analyticsTags = analyticsTags
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "item_name": self.itemName,
            "item_id": self.customerID,
            "url": self.url
        ] as [String: Any]

        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }

        if (self.analyticsTags != nil) {
            dict["analytics_tags"] = self.analyticsTags
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
