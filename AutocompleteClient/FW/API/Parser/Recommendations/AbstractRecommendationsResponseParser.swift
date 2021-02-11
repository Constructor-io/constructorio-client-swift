//
//  AbstractRecommendationsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractRecommendationsResponseParser {

    func parse(recommendationsResponseData: Data) throws -> CIORecommendationsResponse
}
