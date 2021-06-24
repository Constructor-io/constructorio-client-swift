//
//  CIORecommendationsResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the search data response from the server.
 */
public struct CIORecommendationsResponse {
    /**
     Pod information
     */
    public let pod: CIORecommendationsPod

    /**
     List of results returned for the recommendations query
     */
    public let results: [CIOResult]

    /**
     Total number of results for the query
     */
    public let totalNumResults: Int

    /**
     Result ID of the result set returned
     */
    public let resultID: String
}
