//
//  SearchFilters.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias Filter = (key: String, value: String)

public struct CIOQueryFilters {
    public let groupFilter: String?
    public let facetFilters: [Filter]?

    public init(groupFilter: String?, facetFilters: [Filter]?) {
        self.groupFilter = groupFilter
        self.facetFilters = facetFilters
    }
}
