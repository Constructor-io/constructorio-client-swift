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

            let facets: [CIOFilterFacet] = (response["facets"] as? [JSONObject])?.compactMap { obj in
                return CIOFilterFacet(json: obj)
            } ?? []

            let results: [CIOResult] = (response["results"] as? [JSONObject])?.compactMap { obj in
                return CIOResult(json: obj)
            } ?? []

            let sortOptions: [CIOSortOption] = (response["sort_options"] as? [JSONObject])?.compactMap({ obj  in
                return CIOSortOption(json: obj)
            }) ?? []

            let groups: [CIOGroup] = (response["groups"] as? [JSONObject])?.compactMap({ obj  in
                return CIOGroup(json: obj)
            }) ?? []

            let resultID = json?["result_id"] as? String ?? ""
            let totalNumResults = response["total_num_results"] as? Int ?? 0
            return CIOSearchResponse(facets: facets, groups: groups, results: results, redirectInfo: CIOSearchRedirectInfo(object: response["redirect"] as? JSONObject), sortOptions: sortOptions, totalNumResults: totalNumResults, resultID: resultID )
        } catch {
            throw CIOError.invalidResponse
        }

    }
}
