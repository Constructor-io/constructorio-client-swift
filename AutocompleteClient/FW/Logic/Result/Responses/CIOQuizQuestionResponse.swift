//
//  CIOQuizQuestionResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the quiz next question data response from the server.
 */
public struct CIOQuizQuestionResponse {
    /**
     Next question in the quiz
     */
    public let nextQuestion: CIOQuizQuestion
        
    /**
     Version Id of the result question
     */
    public let versionId: String

    /**
     Is the question last
     */
    public let isLastQuestion: Bool
}
