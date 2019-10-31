//
//  RecommendationsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class RecommendationsResponseParser: AbstractRecommendationsResponseParser{
    
    func parse(searchResponseParser: AbstractSearchResponseParser, recommendationsResponseData: Data) throws -> CIORecommendationsResponse {
        do {
            let searchResponse = try searchResponseParser.parse(searchResponseData: recommendationsResponseData)
            
            guard let json = try JSONSerialization.jsonObject(with: recommendationsResponseData) as? JSONObject,
                  let responseDictionary = json["response"] as? JSONObject,
                  let podDictionary = responseDictionary["pod"] as? JSONObject,
                  let podDisplayName = podDictionary["display_name"] as? String,
                  let podID = podDictionary["id"] as? String else{
                throw CIOError.invalidResponse
            }
            
            return CIORecommendationsResponse(pod: Pod(id: podID, displayName: podDisplayName), searchResponse: searchResponse)
        }catch{
            throw CIOError.invalidResponse
        }
    }
}
