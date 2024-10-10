//
//  AbstractBrowseFacetOptionsResponseParser.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractBrowseFacetOptionsResponseParser {

    func parse(browseFacetOptionsResponseData: Data) throws -> CIOBrowseFacetOptionsResponse
}
