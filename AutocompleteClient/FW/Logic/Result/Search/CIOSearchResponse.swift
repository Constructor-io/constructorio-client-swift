//
//  CIOSearchResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the search data response from the server.
 */
public struct CIOSearchResponse {
    public let facets: [Facet]
    public let results: [SearchResult]
    public let groups: [CIOGroup]
    public let redirectInfo: SearchRedirectInfo?
    public let sortOptions: [SortOption]
    public let resultCount: Int
    public let resultID: String

    public var isRedirect: Bool {
        return self.redirectInfo != nil
    }
}
