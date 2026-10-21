//
//  CIOTrackProductInsightsAgentAnswerViewData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a Product Insights Agent answer view
 */
struct CIOTrackProductInsightsAgentAnswerViewData: CIORequestData {

    let itemID: String
    let question: String
    let answerText: String
    let questionTopic: String?
    let qnaResultID: String?
    let items: [CIOItem]?
    let followUpQuestions: [String]?
    let itemName: String?
    let variationID: String?
    let threadID: String?
    let sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackProductInsightsAgentAnswerView.format, baseURL)
    }

    init(itemID: String, question: String, answerText: String, questionTopic: String? = nil, qnaResultID: String? = nil, items: [CIOItem]? = nil, followUpQuestions: [String]? = nil, itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.question = question
        self.answerText = answerText
        self.questionTopic = questionTopic
        self.qnaResultID = qnaResultID
        self.items = items
        self.followUpQuestions = followUpQuestions
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
            "question": self.question,
            "answer_text": self.answerText
        ] as [String: Any]

        if let questionTopic = self.questionTopic {
            dict["question_topic"] = questionTopic
        }
        if let qnaResultID = self.qnaResultID {
            dict["qna_result_id"] = qnaResultID
        }
        if let items = self.items {
            dict["items"] = items.prefix(100).map { $0.productInsightsAgentDictionary() }
        }
        if let followUpQuestions = self.followUpQuestions {
            dict["follow_up_questions"] = followUpQuestions.prefix(100).map { ["value": $0] }
        }
        if let itemName = self.itemName {
            dict["item_name"] = itemName
        }
        if let variationID = self.variationID {
            dict["variation_id"] = variationID
        }
        if let threadID = self.threadID {
            dict["thread_id"] = threadID
        }
        if let analyticsTags = self.analyticsTags {
            dict["analytics_tags"] = analyticsTags
        }

        dict["beacon"] = true
        dict.merge(baseParams) { current, _ in current }

        return try? JSONSerialization.data(withJSONObject: dict)
    }
}

private extension CIOItem {
    // Only the keys accepted by the API are sent. `quantity` is rejected with a 400, so it is never included
    func productInsightsAgentDictionary() -> [String: String] {
        var dict = ["item_id": self.customerID]
        if let itemName = self.itemName {
            dict["item_name"] = itemName
        }
        if let variationID = self.variationID {
            dict["variation_id"] = variationID
        }
        if let campaignID = self.slCampaignID {
            dict["sl_campaign_id"] = campaignID
        }
        if let campaignOwner = self.slCampaignOwner {
            dict["sl_campaign_owner"] = campaignOwner
        }
        return dict
    }
}
