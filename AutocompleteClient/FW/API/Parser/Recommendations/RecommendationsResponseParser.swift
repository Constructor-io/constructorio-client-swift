//
//  RecommendationsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class RecommendationsResponseParser: AbstractRecommendationsResponseParser {
    func parse(recommendationsResponseData: Data) throws -> CIORecommendationsResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: recommendationsResponseData) as? JSONObject

            guard let response = json?["response"] as? JSONObject else {
                throw CIOError.invalidResponse
            }

            let resultsObj: [JSONObject]? = response["results"] as? [JSONObject]

            let results: [CIOResult] = (resultsObj)?.compactMap { obj in return CIOResult(json: obj) } ?? []
            let totalNumResults = response["total_num_results"] as? Int ?? 0
            let resultID = json?["result_id"] as? String ?? ""

            return CIORecommendationsResponse(
                pod: CIOPod(object: response["pod"] as? JSONObject)!, // TODO:: Figure out why it needs to be forced using ! at the end
                results: results,
                totalNumResults: totalNumResults,
                resultID: resultID
            )
        } catch {
            throw CIOError.invalidResponse
        }

    }
}
