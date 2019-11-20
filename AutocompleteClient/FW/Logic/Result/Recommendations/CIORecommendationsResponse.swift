//
//  CIORecommendationsResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct CIORecommendationsResponse{
    public let pod: Pod
    public let results: [RecommendationResult]
    public let sortOptions: [SortOption]
    public let resultCount: Int
    public let resultID: String
}
