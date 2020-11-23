//
//  ResponseParserDelegate.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

protocol ResponseParserDelegate: class {
    func shouldParseResult(result: CIOResult, inGroup group: CIOGroup?) -> Bool?
    func maximumGroupsShownPerResult(result: CIOResult, at index: Int) -> Int
}
