//
//  CIOTrackProductInsightsAgentViewData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a Product Insights Agent view
 */
struct CIOTrackProductInsightsAgentViewData: CIOTrackProductInsightsAgentData {

    let itemID: String
    let questions: [CIOProductInsightsAgentQuestion]
    let itemName: String?
    let variationID: String?
    let threadID: String?
    let sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackProductInsightsAgentView.format, baseURL)
    }

    init(itemID: String, questions: [CIOProductInsightsAgentQuestion], itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.questions = questions
        self.itemName = itemName
        self.variationID = variationID
        self.threadID = threadID
        self.sectionName = sectionName
        self.analyticsTags = analyticsTags
    }

    func eventFields() -> [String: Any] {
        return [
            "questions": self.questions.map { $0.toDictionary() }
        ]
    }
}
