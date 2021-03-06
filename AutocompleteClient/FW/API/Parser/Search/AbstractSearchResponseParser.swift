//
//  AbstractSearchResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractSearchResponseParser {

    func parse(searchResponseData: Data) throws -> CIOSearchResponse
}
