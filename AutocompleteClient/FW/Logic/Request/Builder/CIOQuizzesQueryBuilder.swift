//
//  CIOQuizzesQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an browse query.
 */
public class CIOQuizzesQueryBuilder {

    /**
     The id of the quiz
     */
    let quizId: String

    /**
     A list of answers that be in the following formats:
     * Single Select: "answer1"
     * Multiple Select: "answer1, answer2"
     * Open Text: "true"
     * Cover Page: "seen"
     
     Please refer to "https://docs.constructor.io/rest_api/quiz/using_quizzes/" for additional details
     */
    var answers: [String]?
    
    /**
     Create a Quizzes query builder
     
     - Parameters:
        - quizId: The id of the quiz
        - answers: A list of answers
     */
    
    public init(quizId: String) {
        self.quizId = quizId
    }

    /**
     Add answers
     */
    public func setAnswers(_ answers: [String]) -> CIOQuizzesQueryBuilder {
        self.answers = answers
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let query = CIOQuizzesQueryBuilder(quizId: "quizId")
        .setAnswers(['answer1', 'answer2'])
        .build()
     
     constructor.quizzes(forQuery: query, completionHandler: { ... })
     ```
     */
    
    public func build() -> CIOQuizzesQuery {
        return CIOQuizzesQuery(quizId: quizId, answers: answers)
    }
}
