//
//  CIOSearchResponse.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 9/10/18.
//  Copyright © 2018 xd. All rights reserved.
//

import Foundation

/**
 Struct representing the search data response from the server.
 */
public struct CIOSearchResponse {
    let facets: [Facet]
    let results: [SearchResult]
}
