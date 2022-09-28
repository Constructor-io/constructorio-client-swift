//
//  CIOAnswerQuizQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an browse query.
 */
public class CIOAnswerQuizQueryBuilder {

    /**
     The id of the quiz
     */
    let quizId: String

    /**
     A list of answers in the format ?a=[option_id_1]&a=[option_id_2] with one a parameter for each question. The expected format for each parameter depends on the question type, as described below
     */
    var answers: [String]?
    
    /**
     Creata an Answer Quiz query builder
     
     - Parameters:
        - quizId: The id of the quiz
        - answers: A list of answers in the format ?a=[option_id_1]&a=[option_id_2] with one a parameter for    each question. The expected format for each parameter depends on the question type, as described below
     */
    
    public init(quizId: String, answers: [String]) {
        self.quizId = quizId
        self.answers = answers
    }

    /**
     Add answers
     */
    public func setAnswers(_ answers: [String]) -> CIOAnswerQuizQueryBuilder {
        self.answers = answers
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let query = CIOAnswerQuizQueryBuilder(quizId: "quizId")
        .setAnswers(['answer1', 'answer2'])
        .build()
     
     //?????
     constructor.quizzes(forQuery: query, completionHandler: { ... })
     ```
     */
    
    public func build() -> CIOQuizzesQuery {
        return CIOQuizzesQuery(quizId: quizId, answers: answers)
    }
}
