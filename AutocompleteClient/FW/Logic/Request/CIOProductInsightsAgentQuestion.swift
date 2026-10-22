//
//  CIOProductInsightsAgentQuestion.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing a question shown to the user by the Product Insights Agent
 */
public struct CIOProductInsightsAgentQuestion {

    /**
     The question text (1-1000 characters)
     */
    public let question: String

    /**
     The topic category of the question
     */
    public let questionTopic: String?

    /**
     Create a Product Insights Agent question

     - Parameters:
        - question: The question text (1-1000 characters)
        - questionTopic: The topic category of the question
     */
    public init(question: String, questionTopic: String? = nil) {
        self.question = question
        self.questionTopic = questionTopic
    }

    func toDictionary() -> [String: String] {
        var dict = ["question": self.question]
        if let questionTopic = self.questionTopic {
            dict["question_topic"] = questionTopic
        }
        return dict
    }
}
