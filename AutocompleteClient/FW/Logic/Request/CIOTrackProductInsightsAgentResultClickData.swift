//
//  CIOTrackProductInsightsAgentResultClickData.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that must/can be set in order to track a Product Insights Agent result click
 */
struct CIOTrackProductInsightsAgentResultClickData: CIOTrackProductInsightsAgentData {

    let itemID: String
    let question: String
    let seedItemID: String
    let position: Int?
    let seedItemName: String?
    let seedVariationID: String?
    let qnaResultID: String?
    let itemName: String?
    let variationID: String?
    let threadID: String?
    let sectionName: String?
    let analyticsTags: [String: String]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.TrackProductInsightsAgentResultClick.format, baseURL)
    }

    init(itemID: String, question: String, seedItemID: String, position: Int? = nil, seedItemName: String? = nil, seedVariationID: String? = nil, qnaResultID: String? = nil, itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
        self.itemID = itemID
        self.question = question
        self.seedItemID = seedItemID
        self.position = position
        self.seedItemName = seedItemName
        self.seedVariationID = seedVariationID
        self.qnaResultID = qnaResultID
        self.itemName = itemName
        self.variationID = variationID
        self.threadID = threadID
        self.sectionName = sectionName
        self.analyticsTags = analyticsTags
    }

    func eventFields() -> [String: Any] {
        var dict = [
            "question": self.question,
            "seed_item_id": self.seedItemID
        ] as [String: Any]

        if let position = self.position {
            dict["position"] = position
        }
        if let seedItemName = self.seedItemName {
            dict["seed_item_name"] = seedItemName
        }
        if let seedVariationID = self.seedVariationID {
            dict["seed_variation_id"] = seedVariationID
        }
        if let qnaResultID = self.qnaResultID {
            dict["qna_result_id"] = qnaResultID
        }

        return dict
    }
}
