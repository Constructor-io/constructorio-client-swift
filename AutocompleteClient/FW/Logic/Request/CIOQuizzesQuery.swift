//
//  CIOQuizzesQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
 
/**
 Struct encapsulating the necessary and additional parameters required to execute a quizzes query.
 */
public struct CIOQuizzesQuery: CIORequestData {
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

    public var finalize: Bool = false
    
    func url(with baseURL: String) -> String {
        return String(format: Constants.Quiz.format, baseURL, quizId, finalize == true ? "finalize" : "next")
    }

    /**
     Create a Answer Quiz request query object

     - Parameters:
        - quizId: The id of the quiz
        - answers: A list of answers

     ### Usage Example: ###
     ```
     let quizzesQuery = CIOQuizzesQuery(quizId: "123", answers: ['a', 'b'])
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
