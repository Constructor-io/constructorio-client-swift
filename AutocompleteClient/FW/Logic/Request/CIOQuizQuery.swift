//
//  CIOQuizQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
/**
 Struct encapsulating the necessary and additional parameters required to execute a quiz query.
 */
public struct CIOQuizQuery: CIORequestData {
    /**
     The id of the quiz
     */
    public let quizId: String

    /**
     A list of answers. Please refer to "https://docs.constructor.io/rest_api/quiz/using_quizzes/" for additional details
     */
    public var answers: [[String]]?

    /**
     Specific quiz_version_id for the quiz. 
     Version ID will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.io/rest_api/quiz/using_quizzes/#quiz-versioning
     */
    public var versionId: String?
    
    /**
     Specific quiz_session_id for the quiz.
     Session ID will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.io/rest_api/quiz/using_quizzes/#quiz-sessions
     */
    public var sessionId: String?

    func url(with baseURL: String) -> String {
        return "" // Do nothing - Returns empty string to satsify protocol requirement
    }

    func urlWithFormat(baseURL: String, format: String) -> String {
        return String(format: format, baseURL, quizId)
    }

    /**
     Create a Quiz request query object

     - Parameters:
        - quizId: The id of the quiz
        - answers: A list of answers
        - versionId: The version of the quiz you would like to request
        - sessionId: The session of the quiz you would like to request

     ### Usage Example: ###
     ```
     let quizQuery = CIOQuizQuery(quizId: "123", answers: [["1"], ["1","2"]], versionId: "some-version-id")
     ```
     */
    public init(quizId: String, answers: [[String]]? = nil, versionId: String? = nil, sessionId: String? = nil) {
        self.quizId = quizId
        self.answers = answers
        self.versionId = versionId
        self.sessionId = sessionId
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(answers: self.answers)
        requestBuilder.set(versionId: self.versionId)
        requestBuilder.set(sessionId: self.sessionId)
    }
}
