//
//  CIOQuizQuestionResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the quiz question response from the server.
 */
public struct CIOQuizQuestionResponse {
    /**
     Next question in the quiz
     */
    public let nextQuestion: CIOQuizQuestion

    /**
     Version Id of the quiz
     */
    public let versionId: String

    /**
     Flag to determine if it's the last question in the quiz
     */
    public let isLastQuestion: Bool
}
