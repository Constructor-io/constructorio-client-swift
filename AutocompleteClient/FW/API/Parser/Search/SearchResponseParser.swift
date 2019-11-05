//
//  SearchResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class SearchResponseParser: AbstractSearchResponseParser {
    func parse(searchResponseData: Data) throws -> CIOSearchResponse {
        do {
            let json = try JSONSerialization.jsonObject(with: searchResponseData) as? JSONObject

            guard let response = json?["response"] as? JSONObject else {
                throw CIOError.invalidResponse
            }

            let facets: [Facet] = (response["facets"] as? [JSONObject])?.compactMap { obj in
                return Facet(json: obj)
            } ?? []

            let results: [SearchResult] = (response["results"] as? [JSONObject])?.compactMap { resultObj in
                guard let dataObj = resultObj["data"] as? JSONObject else { return nil }
                guard let value = resultObj["value"] as? String else { return nil }
                guard let data = SearchResultData(json: dataObj) else {
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

                return SearchResult(id: data.id, value: value, data: data, matchedTerms: matchedTerms, variations: variations)
            } ?? []

            let sortOptions: [SortOption] = (response["sort_options"] as? [JSONObject])?.compactMap({ obj  in
                guard let status = obj["status"] as? String else { return nil }
                guard let displayName = obj["display_name"] as? String else { return nil }
                guard let sortOrderStr = obj["sort_order"] as? String else { return nil }
                guard let sortOrder = SortOrder(rawValue: sortOrderStr) else { return nil }
                guard let sortBy = obj["sort_by"] as? String else { return nil }

                return SortOption(displayName: displayName, sortBy: sortBy, sortOrder: sortOrder, status: status)
            }) ?? []

            let groups: [CIOGroup] = (response["groups"] as? [JSONObject])?.compactMap({ obj  in
                return CIOGroup(json: obj)
            }) ?? []

            let resultID = json?["result_id"] as? String ?? ""
            let resultCount = response["total_num_results"] as? Int ?? 0
            return CIOSearchResponse(facets: facets, results: results, groups: groups, redirectInfo: SearchRedirectInfo(object: response["redirect"] as? JSONObject), sortOptions: sortOptions, resultCount: resultCount, resultID: resultID )
        } catch {
            throw CIOError.invalidResponse
        }

    }
}
