//
//  BrowseFacetsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class BrowseFacetOptionsResponseParser: AbstractBrowseFacetOptionsResponseParser {
    func parse(browseFacetOptionsResponseData: Data) throws -> CIOBrowseFacetOptionsResponse {

        do {
            let json = try JSONSerialization.jsonObject(with: browseFacetOptionsResponseData) as? JSONObject

            guard let response = json?["response"] as? JSONObject else {
                throw CIOError(errorType: .invalidResponse)
            }

            let facetsObj: [JSONObject]? = response["facets"] as? [JSONObject]

            let facets: [CIOFilterFacet] = (facetsObj)?.compactMap { obj in return CIOFilterFacet(json: obj) } ?? []
            let resultID = json?["result_id"] as? String ?? ""

            return CIOBrowseFacetOptionsResponse(
                facets: facets,
                resultID: resultID
            )
        } catch {
            throw CIOError(errorType: .invalidResponse)
        }

    }
}
