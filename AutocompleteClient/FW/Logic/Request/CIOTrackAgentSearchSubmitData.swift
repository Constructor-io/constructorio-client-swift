//
//  CIOTrackAgentSearchSubmitData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track an agent search submit
 */
struct CIOTrackAgentSearchSubmitData: CIORequestData {

    let intent: String
    let searchTerm: String
    let searchResultID: String
    var sectionName: String?
    let intentResultID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackAgentSearchSubmit.format, baseURL)
    }

    init(intent: String, searchTerm: String, searchResultID: String, sectionName: String? = nil, intentResultID: String? = nil) {
        self.intent = intent
        self.searchTerm = searchTerm
        self.searchResultID = searchResultID
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
            "search_term": self.searchTerm,
            "search_result_id": self.searchResultID
        ] as [String: Any]

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
