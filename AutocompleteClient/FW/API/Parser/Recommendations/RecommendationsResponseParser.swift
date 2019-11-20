//
//  RecommendationsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class RecommendationsResponseParser: AbstractRecommendationsResponseParser{
    
    func parse(recommendationsResponseData: Data) throws -> CIORecommendationsResponse {
        do {
            guard let json = try JSONSerialization.jsonObject(with: recommendationsResponseData) as? JSONObject,
                  let response = json["response"] as? JSONObject,
                  let podDictionary = response["pod"] as? JSONObject,
                  let podDisplayName = podDictionary["display_name"] as? String,
                  let podID = podDictionary["id"] as? String else {
                throw CIOError.invalidResponse
            }

            let results: [RecommendationResult] = (response["results"] as? [JSONObject])?.compactMap { resultObj in
                guard let dataObj = resultObj["data"] as? JSONObject,
                      let value = resultObj["value"] as? String,
                      let data = SearchResultData(json: dataObj),
                      let strategyJSON = resultObj["strategy"] as? JSONObject,
                      let strategy = strategyJSON["id"] as? String else {
                      return nil
                }

                let matchedTerms = (resultObj["matched_terms"] as? [String]) ?? [String]()

                let variationsJSONArray = (resultObj["variations"] as? [[String: Any]]) ?? [[String: Any]]()
                var variations = [SearchVariation]()
                for variationObj in variationsJSONArray {
                    if let variation = SearchVariation(json: variationObj) {
                        variations.append(variation)
                    }
                }

                return RecommendationResult(id: data.id, value: value, data: data, matchedTerms: matchedTerms, strategy: strategy, variations: variations)
            } ?? []

            let sortOptions: [SortOption] = (response["sort_options"] as? [JSONObject])?.compactMap({ obj  in
                guard let status = obj["status"] as? String else { return nil }
                guard let displayName = obj["display_name"] as? String else { return nil }
                guard let sortOrderStr = obj["sort_order"] as? String else { return nil }
                guard let sortOrder = SortOrder(rawValue: sortOrderStr) else { return nil }
                guard let sortBy = obj["sort_by"] as? String else { return nil }

                return SortOption(displayName: displayName, sortBy: sortBy, sortOrder: sortOrder, status: status)
            }) ?? []

            let resultID = json["result_id"] as? String ?? ""
            let resultCount = response["total_num_results"] as? Int ?? 0

            let pod = Pod(id: podID, displayName: podDisplayName)

            return CIORecommendationsResponse(pod: pod, results: results, sortOptions: sortOptions, resultCount: resultCount, resultID: resultID)
        } catch {
            throw CIOError.invalidResponse
        }

    }
}
