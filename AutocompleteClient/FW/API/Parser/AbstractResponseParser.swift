//
//  AbstractResponseParser.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol AbstractResponseParser {
    
    var delegate: ResponseParserDelegate? { get set }
    
    func parse(autocompleteResponseData: Data) throws -> CIOAutocompleteResponse
}
