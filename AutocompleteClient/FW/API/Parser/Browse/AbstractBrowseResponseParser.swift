//
//  AbstractBrowseResponseParser.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractBrowseResponseParser {

    func parse(browseResponseData: Data) throws -> CIOBrowseResponse
}
