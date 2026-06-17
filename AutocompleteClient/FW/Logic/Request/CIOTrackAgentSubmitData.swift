//
//  CIOTrackAgentSubmitData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track an agent submit
 */
struct CIOTrackAgentSubmitData: CIORequestData {

    let intent: String
    let sectionName: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackAgentSubmit.format, baseURL)
    }

    init(intent: String, sectionName: String? = nil) {
        self.intent = intent
        self.sectionName = sectionName
    }

    func decorateRequest(requestBuilder: RequestBuilder) {}

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "intent": self.intent
        ] as [String: Any]

        if self.sectionName != nil {
            dict["section"] = self.sectionName
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
