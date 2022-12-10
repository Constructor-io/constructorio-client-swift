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
            let versionId = json?["version_id"] as? String ?? ""
            let isLastQuestion = json?["is_last_question"] as? Bool ?? false
            let nextQuestion = CIOQuizQuestion(json: json?["next_question"] as? JSONObject ?? [:])

            return CIOQuizQuestionResponse(
                nextQuestion: nextQuestion!,
                versionId: versionId,
                isLastQuestion: isLastQuestion
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
