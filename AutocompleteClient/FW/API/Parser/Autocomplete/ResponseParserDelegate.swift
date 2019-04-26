//
//  ResponseParserDelegate.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol ResponseParserDelegate: class {
    func shouldParseResult(result: CIOAutocompleteResult, inGroup group: CIOGroup?) -> Bool?
    func maximumGroupsShownPerResult(result: CIOAutocompleteResult, at index: Int) -> Int
}