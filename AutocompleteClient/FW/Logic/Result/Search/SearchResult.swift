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
    public let url: String?
    public let price: String?
    public let quantity: String?
    public let imageURL: String?
    public let facets: [SearchResultFacet]?
    public let groups: [CIOGroup]?

    public let rawJSON: [String: Any]
    
}
