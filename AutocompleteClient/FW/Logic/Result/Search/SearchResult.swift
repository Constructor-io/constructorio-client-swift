//
//  SearchResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct SearchResult {
    let value: String
    let data: SearchResultData
    let matchedTerms: [String]
    let variations: [SearchVariation]
}
