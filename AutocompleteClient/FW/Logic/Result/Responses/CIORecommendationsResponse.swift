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
    public let pod: CIOPod
    public let results: [CIOResult]
    public let totalNumResults: Int
    public let resultID: String
}
