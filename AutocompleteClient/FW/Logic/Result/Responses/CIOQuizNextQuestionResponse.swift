//
//  CIOQuizNextQuestionResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the quiz next question data response from the server.
 */
public struct CIOQuizNextQuestionResponse {
    /**
     Next question in the quiz
     */
    public let nextQuestion: CIOQuizNextQuestionData
        
    /**
     Version Id of the result question
     */
    public let versionId: String

    /**
     Is the question last
     */
    public let isLastQuestion: Bool
}
