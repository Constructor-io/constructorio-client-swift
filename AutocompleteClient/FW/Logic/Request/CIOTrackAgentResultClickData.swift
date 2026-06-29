//
//  CIOTrackAgentResultClickData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track an agent result click
 */
struct CIOTrackAgentResultClickData: CIORequestData {

    let intent: String
    let searchResultID: String
    let itemID: String?
    let itemName: String?
    let variationID: String?
    let sectionName: String?
    let intentResultID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackAgentResultClick.format, baseURL)
    }

    init(intent: String, searchResultID: String, itemID: String? = nil, itemName: String? = nil, variationID: String? = nil, sectionName: String? = nil, intentResultID: String? = nil) {
        self.intent = intent
        self.searchResultID = searchResultID
        self.itemID = itemID
        self.itemName = itemName
        self.variationID = variationID
        self.sectionName = sectionName
        self.intentResultID = intentResultID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "intent": self.intent,
            "search_result_id": self.searchResultID
        ] as [String: Any]

        if self.itemID != nil {
            dict["item_id"] = self.itemID
        }
        if self.itemName != nil {
            dict["item_name"] = self.itemName
        }
        if self.variationID != nil {
            dict["variation_id"] = self.variationID
        }
        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }
        if self.intentResultID != nil {
            dict["intent_result_id"] = self.intentResultID
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
