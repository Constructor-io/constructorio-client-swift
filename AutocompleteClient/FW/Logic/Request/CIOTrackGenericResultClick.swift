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

    let itemId: String
    let itemName: String
    let variationId: String?
    let sectionName: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackGenericResultClick.format, baseURL)
    }

    init(itemId: String, itemName: String, variationId: String? = nil, sectionName: String? = nil) {
        self.itemId = itemId
        self.itemName = itemName
        self.variationId = variationId
        self.sectionName = sectionName
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "item_id": self.itemId
            "item_name": self.itemName,
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
