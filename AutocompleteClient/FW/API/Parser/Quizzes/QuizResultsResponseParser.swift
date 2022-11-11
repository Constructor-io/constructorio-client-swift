//
//  QuizResultsResponseParser.swift
//  ConstructorAutocomplete
//
//  Created by Islam Mouatafa on 11/11/22.
//  Copyright © 2022 xd. All rights reserved.
//

import Foundation

class QuizResultsResponseParser: AbstractQuizResultsResponseParser {
    func parse(quizResultsResponseData: Data) throws -> CIOQuizResultsResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: quizResultsResponseData) as? JSONObject
            let versionId = json?["version_id"] as? String ?? ""
            let result = CIOQuizResultsData(json: json?["result"] as? JSONObject ?? [:])

            return CIOQuizResultsResponse( 
                result: result!,
                versionId: versionId
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
