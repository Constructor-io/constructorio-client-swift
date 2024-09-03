//
//  AbstractSearchResponseParser.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractSearchResponseParser {

    func parse(searchResponseData: Data) throws -> CIOSearchResponse
}
