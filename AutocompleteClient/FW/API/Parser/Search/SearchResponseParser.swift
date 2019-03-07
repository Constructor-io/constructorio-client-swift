//
//  SearchResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class SearchResponseParser: AbstractSearchResponseParser{
    func parse(searchResponseData: Data) throws -> CIOSearchResponse{
        
        do {
            let json = try JSONSerialization.jsonObject(with: searchResponseData) as? JSONObject
            
            guard let response = json?["response"] as? JSONObject else{
                throw CIOError.invalidResponse
            }
            
            let facets: [Facet] = (response["facets"] as? [JSONObject])?.flatMap { obj in
                return Facet(json: obj)
            } ?? []
            
            let results: [SearchResult] = (response["results"] as? [JSONObject])?.flatMap{ resultObj in
                guard let dataObj = resultObj["data"] as? JSONObject else { return nil }
                guard let value = resultObj["value"] as? String else { return nil }
                guard let data = SearchResultData(json: dataObj) else {
                    return nil
                }

                let matchedTerms = (resultObj["matched_terms"] as? [String]) ?? [String]()
                return SearchResult(value: value, data: data, matchedTerms: matchedTerms)
            } ?? []

            return CIOSearchResponse(facets: facets, results: results, redirectInfo: SearchRedirectInfo(object: response["redirect"] as? JSONObject))
        } catch {
            throw CIOError.invalidResponse
        }
        
    }
}
