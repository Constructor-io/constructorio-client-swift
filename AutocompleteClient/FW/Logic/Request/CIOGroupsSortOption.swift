//
//  CIOGroupsSortOption.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating a group sort option
 */
public struct CIOGroupsSortOption {
    /**
     The sort method ("relevance", "value", or "num_matches")
     */
    public let sortBy: CIOGroupsSortBy

    /**
     The sort order (i.e. "ascending" or "descending")
     */
    public let sortOrder: CIOGroupsSortOrder

    /**
     Create a groups sort option
     
     -  parameters
        - sortBy: The sort method ("relevance", "value", or "num_matches")
        - sortOrder: The sort order (i.e. "ascending" or "descending"
     */
    public init(sortBy: CIOGroupsSortBy, sortOrder: CIOGroupsSortOrder) {
        self.sortBy = sortBy
        self.sortOrder = sortOrder
    }

    public enum CIOGroupsSortBy: String {
        case relevance
        case value
        case num_matches
    }

    public enum CIOGroupsSortOrder: String {
        case ascending
        case descending
    }
}
