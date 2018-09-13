//
//  SearchResult.swift
//  AutocompleteClient
//
//  Created by Nikola Markovic on 9/10/18.
//  Copyright © 2018 xd. All rights reserved.
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
