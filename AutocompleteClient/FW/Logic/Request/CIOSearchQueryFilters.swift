//
//  CIOSearchQueryFilters.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public typealias Filter = (key: String, value: String)

public struct CIOSearchQueryFilters {
    public let groupFilter: String?
    public let facetFilters: [Filter]?

    public init(groupFilter: String?, facetFilters: [Filter]?){
        self.groupFilter = groupFilter
        self.facetFilters = facetFilters
    }
}
