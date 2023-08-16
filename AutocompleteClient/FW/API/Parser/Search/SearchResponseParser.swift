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
                throw CIOError(errorType: .invalidResponse)
            }

            let facetsObj: [JSONObject]? = response["facets"] as? [JSONObject]
            let resultsObj: [JSONObject]? = response["results"] as? [JSONObject]
            let sortOptionsObj: [JSONObject]? = response["sort_options"] as? [JSONObject]
            let groupsObj = response["groups"] as? [JSONObject]
            let refinedContentObj = response["refined_content"] as? [JSONObject]

            let facets: [CIOFilterFacet] = (facetsObj)?.compactMap { obj in return CIOFilterFacet(json: obj) } ?? []
            let results: [CIOResult] = (resultsObj)?.compactMap { obj in return CIOResult(json: obj) } ?? []
            let sortOptions: [CIOSortOption] = (sortOptionsObj)?.compactMap({ obj  in return CIOSortOption(json: obj) }) ?? []
            let groups: [CIOFilterGroup] = groupsObj?.compactMap({ obj  in return CIOFilterGroup(json: obj) }) ?? []
            let totalNumResults = response["total_num_results"] as? Int ?? 0
            let resultID = json?["result_id"] as? String ?? ""
            let resultSources: CIOResultSources? = CIOResultSources(json: response["result_sources"] as? JSONObject)
            let refinedContent: [CIORefinedContent] = refinedContentObj?.compactMap({ obj in return CIORefinedContent(json: obj) }) ?? []

            guard let request: JSONObject = json?["request"] as? JSONObject else {
                throw CIOError(errorType: .invalidResponse)
            }

            return CIOSearchResponse(
                facets: facets,
                groups: groups,
                results: results,
                redirectInfo: CIOSearchRedirectInfo(object: response["redirect"] as? JSONObject),
                sortOptions: sortOptions,
                totalNumResults: totalNumResults,
                resultID: resultID,
                resultSources: resultSources,
                refinedContent: refinedContent,
                request: request
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
