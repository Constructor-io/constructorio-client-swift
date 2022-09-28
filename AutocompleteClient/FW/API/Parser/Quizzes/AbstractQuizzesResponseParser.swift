//
//  AbstractQuizzesResponseParser.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol AbstractQuizzesResponseParser {

    func parse(quizzesResponseData: Data) throws -> CIOQuizzesResponse
}
