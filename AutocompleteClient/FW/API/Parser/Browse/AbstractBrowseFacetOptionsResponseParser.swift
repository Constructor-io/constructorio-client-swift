//
//  AbstractBrowseFacetOptionsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractBrowseFacetOptionsResponseParser {

    func parse(browseFacetOptionsResponseData: Data) throws -> CIOBrowseFacetOptionsResponse
}
