//
//  QuizzesResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class QuizzesResponseParser: AbstractQuizzesResponseParser {
    func parse(quizzesResponseData: Data) throws -> CIOQuizzesResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: quizzesResponseData) as? JSONObject

            guard let nextQuestion = json?["next_question"] as? CIOQuestionData else {
                throw CIOError(errorType: .invalidResponse)
            }
            let versionId = json?["version_id"] as? String
            let isLastQuestion = json?["is_last_question"] as? Bool

            return CIOQuizzesResponse(
                nextQuestion: nextQuestion,
                versionId: versionId,
                isLastQuestion: isLastQuestion
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
