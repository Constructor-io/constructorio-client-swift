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
     Specific quiz_version_id for the quiz. 
     Version ID will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.io/rest_api/quiz/using_quizzes/#quiz-versioning
     */
    public let versionId: String
    
    /**
     Specific quiz_session_id for the quiz.
     Session ID will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.io/rest_api/quiz/using_quizzes/#quiz-sessions
     */
    public let sessionId: String

    /**
     Id of the quiz
     */
    public let quizId: String

    /**
     Flag to determine if it's the last question in the quiz
     */
    public let isLastQuestion: Bool
}
