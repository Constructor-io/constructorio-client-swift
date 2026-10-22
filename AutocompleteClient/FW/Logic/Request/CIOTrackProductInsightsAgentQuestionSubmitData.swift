//
//  CIOTrackProductInsightsAgentQuestionSubmitData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a Product Insights Agent question submit
 */
struct CIOTrackProductInsightsAgentQuestionSubmitData: CIOTrackProductInsightsAgentData {

    let itemID: String
    let question: String
    let questionTopic: String?
    let itemName: String?
    let variationID: String?
    let threadID: String?
    let sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackProductInsightsAgentQuestionSubmit.format, baseURL)
    }

    init(itemID: String, question: String, questionTopic: String? = nil, itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.question = question
        self.questionTopic = questionTopic
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
            "question": self.question
        ] as [String: Any]

        if let questionTopic = self.questionTopic {
            dict["question_topic"] = questionTopic
        }
        self.addCommonFields(to: &dict)

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}
