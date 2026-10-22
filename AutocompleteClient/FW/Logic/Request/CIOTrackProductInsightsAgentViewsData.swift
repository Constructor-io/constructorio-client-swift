//
//  CIOTrackProductInsightsAgentViewsData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a Product Insights Agent views
 */
struct CIOTrackProductInsightsAgentViewsData: CIOTrackProductInsightsAgentData {

    let itemID: String
    let questions: [CIOProductInsightsAgentQuestion]
    let viewTimespans: [CIOProductInsightsAgentViewTimespan]
    let itemName: String?
    let variationID: String?
    let threadID: String?
    let sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackProductInsightsAgentViews.format, baseURL)
    }

    init(itemID: String, questions: [CIOProductInsightsAgentQuestion], viewTimespans: [CIOProductInsightsAgentViewTimespan], itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.questions = questions
        self.viewTimespans = viewTimespans
        self.itemName = itemName
        self.variationID = variationID
        self.threadID = threadID
        self.sectionName = sectionName
        self.analyticsTags = analyticsTags
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(autocompleteSection: self.sectionName)
    }

    func httpMethod() -> String {
        return "POST"
    }

    func httpBody(baseParams: [String: Any]) -> Data? {
        var dict = [
            "item_id": self.itemID,
            "questions": self.questions.map { $0.toDictionary() },
            "view_timespans": self.viewTimespans.map { $0.toDictionary() }
        ] as [String: Any]

        self.addCommonFields(to: &dict)

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
