//
//  SearchFilters.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias Filter = (key: String, value: String)

public struct SearchFilters {
    public let groupFilter: String?
    public let facetFilters: [Filter]?
}
