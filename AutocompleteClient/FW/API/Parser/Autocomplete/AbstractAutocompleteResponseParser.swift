//
//  AbstractAutocompleteResponseParser.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol AbstractAutocompleteResponseParser {

    var delegate: ResponseParserDelegate? { get set }
    var maxGroups: Int? { get set }
    func parse(autocompleteResponseData: Data) throws -> CIOAutocompleteResponse
}
