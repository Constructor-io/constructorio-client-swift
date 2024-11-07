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
     Unique quiz_version_id for the quiz. 
     The quiz version id will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.com/reference/configuration-quizzes
     */
    public let quizVersionID: String

    /**
     Unique quiz_session_id for the quiz.
     The quiz session id will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.com/reference/configuration-quizzes
     */
    public let quizSessionID: String

    /**
     Id of the quiz
     */
    public let quizID: String
}
