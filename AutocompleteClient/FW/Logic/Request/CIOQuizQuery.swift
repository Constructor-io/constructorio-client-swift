//
//  CIOQuizQuery.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
    public let quizID: String

    /**
     A list of answers. Please refer to "https://docs.constructor.com/reference/configuration-quizzes" for additional details
     */
    public var answers: [[String]]?

    /**
     Unique quiz_version_id for the quiz.
     The quiz version id will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.com/reference/configuration-quizzes
     */
    public var quizVersionID: String?

    /**
     Unique quiz_session_id for the quiz.
     The quiz session id will be returned with the first request and it should be passed with subsequent requests.
     More information can be found: https://docs.constructor.com/reference/configuration-quizzes
     */
    public var quizSessionID: String?

    func url(with baseURL: String) -> String {
        return "" // Do nothing - Returns empty string to satsify protocol requirement
    }

    func urlWithFormat(baseURL: String, format: String) -> String {
        return String(format: format, baseURL, quizID)
    }

    /**
     Create a Quiz request query object

     - Parameters:
        - quizID: The id of the quiz
        - answers: A list of answers
        - quizVersionID: The version of the quiz you would like to request
        - quizSessionID: The identifier for the current session of the quiz

     ### Usage Example: ###
     ```
     let quizQuery = CIOQuizQuery(quizID: "123", answers: [["1"], ["1","2"]], quizVersionID: "some-version-id")
     ```
     */
    public init(quizID: String, answers: [[String]]? = nil, quizVersionID: String? = nil, quizSessionID: String? = nil) {
        self.quizID = quizID
        self.answers = answers
        self.quizVersionID = quizVersionID
        self.quizSessionID = quizSessionID
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(answers: self.answers)
        requestBuilder.set(quizVersionID: self.quizVersionID)
        requestBuilder.set(quizSessionID: self.quizSessionID)
    }
}
