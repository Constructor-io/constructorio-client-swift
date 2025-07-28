//
//  CIOTrackGenericResultClick.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track generic result click
 */
struct CIOTrackGenericResultClick: CIORequestData {

    let itemID: String
    let itemName: String
    let variationID: String?
    let sectionName: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackGenericResultClick.format, baseURL)
    }

    init(itemID: String, itemName: String, variationID: String? = nil, sectionName: String? = nil) {
        self.itemID = itemID
        self.itemName = itemName
        self.variationID = variationID
        self.sectionName = sectionName
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "item_id": self.itemID,
            "item_name": self.itemName
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
