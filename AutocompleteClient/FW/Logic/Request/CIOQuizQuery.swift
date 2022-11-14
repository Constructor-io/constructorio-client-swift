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
     A list of answers that be in the following formats:
     * Single Select: "answer1"
     * Multiple Select: "answer1, answer2"
     * Open Text: "true"
     * Cover Page: "seen"
     
     Please refer to "https://docs.constructor.io/rest_api/quiz/using_quizzes/" for additional details
     */
    public var answers: [String]?

    public var finalize: Bool?

    func url(with baseURL: String) -> String {
        let format = finalize == true ? Constants.Quiz.Results.format : Constants.Quiz.Question.format
        return String(format: format, baseURL , quizId)
    }

    /**
     Create a Quiz request query object

     - Parameters:
        - quizId: The id of the quiz
        - answers: A list of answers
        - finalize: Finalize quiz submission

     ### Usage Example: ###
     ```
     let quizQuesitonQuery = CIOQuizQuery(quizId: "123", answers: ['a', 'b'])
     let quizResultsQuery = CIOQuizQuery(quizId: "123", answers: ['a', 'b'], finalize: true)
     ```
     */
    public init(quizId: String, answers: [String]? = nil, finalize: Bool? = false) {
        self.quizId = quizId
        self.answers = answers
        self.finalize = finalize
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(answers: self.answers)
    }
}
