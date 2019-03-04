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
                guard let name = obj["name"] as? String else { return nil }
                let options: [FacetOption] = (obj["options"] as? [JSONObject])?.flatMap { option in
                    guard let count = option["count"] as? Int else { return nil }
                    guard let value = option["value"] as? String else { return nil }
                    return FacetOption(count: count, value: value)
                } ?? []
                return Facet(name: name, options: options)
            } ?? []
            
            let results: [SearchResult] = (response["results"] as? [JSONObject])?.flatMap{ resultObj in
                guard let dataObj = resultObj["data"] as? JSONObject else { return nil }
                
                guard let id = dataObj["id"] as? String else { return nil }
                
                guard let value = resultObj["value"] as? String else { return nil }
                
                let imageURL = dataObj["image_url"] as? String
                let price = dataObj["price"] as? String
                let quantity = dataObj["quantity"] as? String
                let url = dataObj["url"] as? String
                
                let searchFacets: [SearchResultFacet]? = (dataObj["facets"] as? [JSONObject])?.flatMap{ searchFacetObj in
                    return SearchResultFacet(json: searchFacetObj)
                }
                
                let groups: [CIOGroup]? = (dataObj["groups"] as? [JSONObject])?.flatMap({ groupObj in
                    return CIOGroup(json: groupObj)
                })
                
                return SearchResult(id: id, value: value, url: url, price: price, quantity: quantity, imageURL: imageURL, facets: searchFacets, groups: groups)
            } ?? []

            return CIOSearchResponse(facets: facets, results: results, redirectInfo: SearchRedirectInfo(object: response["redirect"] as? JSONObject))
        } catch {
            throw CIOError.invalidResponse
        }
        
    }
}
