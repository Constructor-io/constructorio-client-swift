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
struct CIOTrackProductInsightsAgentAnswerViewData: CIOTrackProductInsightsAgentData {

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

    func eventFields() -> [String: Any] {
        var dict = [
            "question": self.question,
            "answer_text": self.truncatedAnswerText()
        ] as [String: Any]

        if let questionTopic = self.questionTopic {
            dict["question_topic"] = questionTopic
        }
        if let qnaResultID = self.qnaResultID {
            dict["qna_result_id"] = qnaResultID
        }
        if let items = self.items {
            dict["items"] = items.prefix(100).map { self.itemDictionary(from: $0) }
        }
        if let followUpQuestions = self.followUpQuestions {
            dict["follow_up_questions"] = followUpQuestions.prefix(100).map { ["value": $0] }
        }

        return dict
    }

    // The server rejects answer_text over 2000 Unicode code points with a 400, which drops the whole event.
    // Truncate on character boundaries so a multi-scalar character (e.g. an accent or emoji sequence) is never split
    private func truncatedAnswerText() -> String {
        guard self.answerText.unicodeScalars.count > 2000 else {
            return self.answerText
        }
        var scalarCount = 0
        var endIndex = self.answerText.startIndex
        for character in self.answerText {
            scalarCount += character.unicodeScalars.count
            if scalarCount > 2000 {
                break
            }
            endIndex = self.answerText.index(after: endIndex)
        }
        return String(self.answerText[..<endIndex])
    }

    private func itemDictionary(from item: CIOItem) -> [String: String] {
        var dict = ["item_id": item.customerID]
        if let itemName = item.itemName {
            dict["item_name"] = itemName
        }
        if let variationID = item.variationID {
            dict["variation_id"] = variationID
        }
        if let slCampaignID = item.slCampaignID {
            dict["sl_campaign_id"] = slCampaignID
        }
        if let slCampaignOwner = item.slCampaignOwner {
            dict["sl_campaign_owner"] = slCampaignOwner
        }
        return dict
    }
}
