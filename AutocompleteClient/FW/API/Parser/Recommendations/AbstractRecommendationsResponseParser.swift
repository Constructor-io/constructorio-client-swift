//
//  AbstractRecommendationsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractRecommendationsResponseParser {
    func parse(searchResponseParser: AbstractSearchResponseParser, recommendationsResponseData: Data) throws -> CIORecommendationsResponse
}
