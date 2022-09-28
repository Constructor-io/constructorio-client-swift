//
//  CIOQuizzesQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a search query.
 */
public struct CIOQuizzesQuery: CIORequestData {
    /**
     The id of the quiz
     */
    public let quizId: String

    /**
     A list of answers in the format ?a=[option_id_1]&a=[option_id_2] with one a parameter for each question. The expected format for each parameter depends on the question type, as described below
     */
    public let answers: [String]?

    public var finalize: Bool = false
    
    func url(with baseURL: String) -> String {
        return String(format: Constants.Quiz.format, baseURL, quizId, finalize == true ? "finalize" : "next")
    }

    /**
     Create a Answer Quiz request query object

     - Parameters:
        - quizId: The id of the quiz
        - answers: A list of answers in the format ?a=[option_id_1]&a=[option_id_2] with one a parameter for each question. The expected format for    each parameter depends on the question type, as described below.

     ### Usage Example: ###
     ```

     let answerQuizQuery = CIOQuizzesQuery(quizId: "123", answers: ['a', 'b'])
     ```
     */
    public init(quizId: String, answers: [String]? = nil) {
        self.quizId = quizId
        self.answers = answers
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(answers: self.answers)
    }
}
