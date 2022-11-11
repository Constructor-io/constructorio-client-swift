//
//  QuizNextQuestionResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class QuizNextQuestionResponseParser: AbstractQuizNextQuestionResponseParser {
    func parse(quizNextQuestionResponseData: Data) throws -> CIOQuizNextQuestionResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: quizNextQuestionResponseData) as? JSONObject
            let versionId = json?["version_id"] as? String ?? ""
            let isLastQuestion = json?["is_last_question"] as? Bool ?? false
            let nextQuestion = CIOQuizNextQuestionData(json: json?["next_question"] as? JSONObject ?? [:])

            return CIOQuizNextQuestionResponse(
                nextQuestion: nextQuestion!,
                versionId: versionId,
                isLastQuestion: isLastQuestion
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
