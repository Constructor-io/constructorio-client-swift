//
//  SearchResult.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct SearchResult {
    let id: String
    let value: String
    let url: String?
    let price: String?
    let quantity: String?
    let imageURL: String?
    let facets: [SearchResultFacet]?
    let groups: [CIOGroup]?
    
}
