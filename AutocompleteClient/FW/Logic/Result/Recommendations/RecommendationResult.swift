//
//  RecommendationResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct RecommendationResult{
    public let id: String
    public let value: String
    public let data: SearchResultData
    public let matchedTerms: [String]
    public let strategy: String
    public let variations: [SearchVariation]
}
