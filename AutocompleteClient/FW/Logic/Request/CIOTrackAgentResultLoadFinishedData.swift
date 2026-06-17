//
//  CIOTrackAgentResultLoadFinishedData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track an agent result load finished
 */
struct CIOTrackAgentResultLoadFinishedData: CIORequestData {

    let intent: String
    let searchResultCount: Int
    let sectionName: String?
    let intentResultID: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackAgentResultLoadFinished.format, baseURL)
    }

    init(intent: String, searchResultCount: Int, sectionName: String? = nil, intentResultID: String? = nil) {
        self.intent = intent
        self.searchResultCount = searchResultCount
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
            "search_result_count": Int(self.searchResultCount)
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
