//
//  QuizQuestionResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class QuizQuestionResponseParser: AbstractQuizQuestionResponseParser {
    func parse(quizQuestionResponseData: Data) throws -> CIOQuizQuestionResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: quizQuestionResponseData) as? JSONObject
            let quizVersionID = json?["quiz_version_id"] as? String ?? ""
            let quizID = json?["quiz_id"] as? String ?? ""
            let quizSessionID = json?["quiz_session_id"] as? String ?? ""
            let isLastQuestion = json?["is_last_question"] as? Bool ?? false
            let nextQuestion = CIOQuizQuestion(json: json?["next_question"] as? JSONObject ?? [:])

            return CIOQuizQuestionResponse(
                nextQuestion: nextQuestion!,
                quizVersionID: quizVersionID,
                quizSessionID: quizSessionID,
                quizID: quizID,
                isLastQuestion: isLastQuestion
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
