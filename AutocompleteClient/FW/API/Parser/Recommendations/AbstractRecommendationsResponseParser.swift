//
//  AbstractRecommendationsResponseParser.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractRecommendationsResponseParser {

    func parse(recommendationsResponseData: Data) throws -> CIORecommendationsResponse
}
