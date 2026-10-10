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

class RecommendationPageResponseParser {
    let podParser = RecommendationsResponseParser()

    func parse(recommendationPageResponseData: Data) throws -> CIORecommendationPageResponse {
        guard let json = try? JSONSerialization.jsonObject(with: recommendationPageResponseData) as? JSONObject,
              let response = json["response"] as? JSONObject,
              let podsObj = response["pods"] as? [JSONObject] else {
            throw CIOError(errorType: .invalidResponse)
        }

        let pods: [CIORecommendationPagePod] = try podsObj.map { podObj in
            guard let podID = podObj["pod_id"] as? String else {
                throw CIOError(errorType: .invalidResponse)
            }
            let podResultID = podObj["result_id"] as? String ?? ""
            var podRequest = podObj["request"] as? JSONObject ?? [:]
            podRequest["pod_id"] = podID
            var podResponse = podObj["response"] as? JSONObject ?? ["results": [JSONObject](), "total_num_results": 0]
            if podResponse["pod"] as? JSONObject == nil {
                podResponse["pod"] = ["id": podID, "display_name": podID]
            }

            // Parse each pod as a single-pod response carrying the pod's own result_id, never the page's
            let podJSON: JSONObject = ["response": podResponse, "request": podRequest, "result_id": podResultID]
            let podData = try JSONSerialization.data(withJSONObject: podJSON)

            return CIORecommendationPagePod(
                podID: podID,
                resultID: podResultID,
                response: try self.podParser.parse(recommendationsResponseData: podData)
            )
        }

        return CIORecommendationPageResponse(
            pageID: response["page_id"] as? String ?? "",
            displayName: response["display_name"] as? String,
            pageType: response["page_type"] as? String,
            pods: pods,
            resultID: json["result_id"] as? String ?? "",
            request: json["request"] as? JSONObject ?? [:]
        )
    }
}
