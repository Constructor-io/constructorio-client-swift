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
            let versionId = json?["quiz_version_id"] as? String ?? ""
            let quizId = json?["quiz_id"] as? String ?? ""
            let sessionId = json?["quiz_session_id"] as? String ?? ""
            let isLastQuestion = json?["is_last_question"] as? Bool ?? false
            let nextQuestion = CIOQuizQuestion(json: json?["next_question"] as? JSONObject ?? [:])

            return CIOQuizQuestionResponse(
                nextQuestion: nextQuestion!,
                versionId: versionId,
                sessionId: sessionId,
                quizId: quizId,
                isLastQuestion: isLastQuestion
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
