//
//  SearchFilters.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

typealias Filter = (key: String, value: String)

struct SearchFilters{
    let groupFilter: String?
    let facetFilters: [Filter]?
}
