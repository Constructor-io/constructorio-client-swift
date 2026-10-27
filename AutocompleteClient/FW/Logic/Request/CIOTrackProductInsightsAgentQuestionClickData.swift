//
//  CIOTrackProductInsightsAgentQuestionClickData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a Product Insights Agent question click
 */
struct CIOTrackProductInsightsAgentQuestionClickData: CIOTrackProductInsightsAgentData {

    let itemID: String
    let question: String
    let questionTopic: String?
    let itemName: String?
    let variationID: String?
    let threadID: String?
    let sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackProductInsightsAgentQuestionClick.format, baseURL)
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

    func eventFields() -> [String: Any] {
        var dict = [
            "question": self.question
        ] as [String: Any]

        if let questionTopic = self.questionTopic {
            dict["question_topic"] = questionTopic
        }

        return dict
    }
}
