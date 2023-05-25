//
//  AbstractBrowseFacetsResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractBrowseFacetsResponseParser {

    func parse(browseFacetsResponseData: Data) throws -> CIOBrowseFacetsResponse
}
