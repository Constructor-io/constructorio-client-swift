//
//  RecommendationsResponseParser.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

class RecommendationsResponseParser: AbstractRecommendationsResponseParser {
    func parse(recommendationsResponseData: Data) throws -> CIORecommendationsResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: recommendationsResponseData) as? JSONObject

            guard let response = json?["response"] as? JSONObject else {
                throw CIOError(errorType: .invalidResponse)
            }

            let resultsObj: [JSONObject]? = response["results"] as? [JSONObject]

            let results: [CIOResult] = (resultsObj)?.compactMap { obj in return CIOResult(json: obj) } ?? []
            let totalNumResults = response["total_num_results"] as? Int ?? 0
            let resultID = json?["result_id"] as? String ?? ""

            guard let request: JSONObject = json?["request"] as? JSONObject else {
                throw CIOError(errorType: .invalidResponse)
            }

            // swiftlint:disable force_cast
            return CIORecommendationsResponse(
                pod: CIORecommendationsPod(json: response["pod"] as! JSONObject)!,
                results: results,
                totalNumResults: totalNumResults,
                resultID: resultID,
                request: request
            )
            // swiftlint:enable force_cast
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
