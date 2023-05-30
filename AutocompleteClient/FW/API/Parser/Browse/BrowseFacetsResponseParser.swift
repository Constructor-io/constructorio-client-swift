//
//  BrowseFacetsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class BrowseFacetsResponseParser: AbstractBrowseFacetsResponseParser {
    func parse(browseFacetsResponseData: Data) throws -> CIOBrowseFacetsResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: browseFacetsResponseData) as? JSONObject

            guard let response = json?["response"] as? JSONObject else {
                throw CIOError(errorType: .invalidResponse)
            }

            let facetsObj: [JSONObject]? = response["facets"] as? [JSONObject]

            let facets: [CIOFilterFacet] = (facetsObj)?.compactMap { obj in return CIOFilterFacet(json: obj) } ?? []
            let totalNumResults = response["total_num_results"] as? Int ?? 0
            let resultID = json?["result_id"] as? String ?? ""

            return CIOBrowseFacetsResponse(
                facets: facets,
                totalNumResults: totalNumResults,
                resultID: resultID
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
