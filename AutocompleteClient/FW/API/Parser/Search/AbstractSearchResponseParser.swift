//
//  AbstractSearchResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol AbstractSearchResponseParser{
    
    func parse(searchResponseData: Data) throws -> CIOSearchResponse
}
