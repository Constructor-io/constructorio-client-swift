//
//  AbstractResponseParser.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractResponseParser {
    func parse(autocompleteResponseData: Data) throws -> CIOResponse
}
