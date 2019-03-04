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
    let redirectInfo: SearchRedirectInfo?

    var isRedirect: Bool{
        get{
            return self.redirectInfo != nil
        }
    }
}
