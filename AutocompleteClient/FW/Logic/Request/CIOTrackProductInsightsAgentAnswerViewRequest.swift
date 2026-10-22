//
//  CIOTrackProductInsightsAgentAnswerViewRequest.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that can be passed to constructorIO.trackProductInsightsAgentAnswerView() function.
 */
public struct CIOTrackProductInsightsAgentAnswerViewRequest {

    /**
     The ID of the product whose page the Product Insights Agent is on
     */
    public let itemID: String

    /**
     The question the answer was provided for (1-1000 characters)
     */
    public let question: String

    /**
     The text of the answer shown to the user (an empty string is allowed)
     */
    public let answerText: String

    /**
     The topic category of the question
     */
    public let questionTopic: String?

    /**
     The ID of the answer result returned by the Product Insights Agent
     */
    public let qnaResultID: String?

    /**
     The recommended items shown with the answer (capped at 100). `quantity` is not sent
     */
    public let items: [CIOItem]?

    /**
     The follow-up questions shown with the answer (capped at 100)
     */
    public let followUpQuestions: [String]?

    /**
     The name of the product whose page the Product Insights Agent is on
     */
    public let itemName: String?

    /**
     The variation ID of the product whose page the Product Insights Agent is on
     */
    public let variationID: String?

    /**
     The ID used to group events within a single conversation thread
     */
    public let threadID: String?

    /**
     The name of the section the item belongs to (defaults to the configured default section, or "Products")
     */
    public let sectionName: String?

    /**
     Additional custom analytics tags to be sent with the event. Merged with the default analytics tags
     */
    public let analyticsTags: [String: String]?

    /**
     Create a Product Insights Agent answer view request

     - Parameters:
        - itemID: The ID of the product whose page the Product Insights Agent is on
        - question: The question the answer was provided for (1-1000 characters)
        - answerText: The text of the answer shown to the user (an empty string is allowed)
        - questionTopic: The topic category of the question
        - qnaResultID: The ID of the answer result returned by the Product Insights Agent
        - items: The recommended items shown with the answer (capped at 100). `quantity` is not sent
        - followUpQuestions: The follow-up questions shown with the answer (capped at 100)
        - itemName: The name of the product whose page the Product Insights Agent is on
        - variationID: The variation ID of the product whose page the Product Insights Agent is on
        - threadID: The ID used to group events within a single conversation thread
        - sectionName: The name of the section the item belongs to (defaults to the configured default section, or "Products")
        - analyticsTags: Additional custom analytics tags to be sent with the event. Merged with the default analytics tags
     */
    public init(itemID: String, question: String, answerText: String, questionTopic: String? = nil, qnaResultID: String? = nil, items: [CIOItem]? = nil, followUpQuestions: [String]? = nil, itemName: String? = nil, variationID: String? = nil, threadID: String? = nil, sectionName: String? = nil, analyticsTags: [String: String]? = nil) {
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
}
