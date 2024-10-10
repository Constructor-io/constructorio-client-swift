//
//  AbstractBrowseFacetsResponseParser.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractBrowseFacetsResponseParser {

    func parse(browseFacetsResponseData: Data) throws -> CIOBrowseFacetsResponse
}
