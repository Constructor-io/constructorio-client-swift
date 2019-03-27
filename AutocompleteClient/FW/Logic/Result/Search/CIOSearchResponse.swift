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
    let facets: [Facet]
    let results: [SearchResult]
    let groups: [CIOGroup]
    let redirectInfo: SearchRedirectInfo?
    let sortOptions: [SortOption]

    let resultCount: Int
    let resultID: String

    var isRedirect: Bool{
        get{
            return self.redirectInfo != nil
        }
    }
}
