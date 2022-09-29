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

            let versionId = json?["version_id"] as? String
            let isLastQuestion = json?["is_last_question"] as? Bool
            
            let nextQuestion = CIONextQuestionData(json: json?["next_question"] as? JSONObject ?? [:])
            let result = CIOQuizResultData(json: json?["result"] as? JSONObject ?? [:])

            return CIOQuizzesResponse(
                nextQuestion: nextQuestion,
                result: result,
                versionId: versionId,
                isLastQuestion: isLastQuestion
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
