//
//  AbstractBrowseResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractBrowseResponseParser {

    func parse(browseResponseData: Data) throws -> CIOBrowseResponse
}
