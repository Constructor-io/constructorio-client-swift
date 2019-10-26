//
//  SearchResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct SearchResult {
    public let id: String
    public let value: String
    public let data: SearchResultData
    public let matchedTerms: [String]
    public let variations: [SearchVariation]
}

extension SearchResult: Identifiable {}
