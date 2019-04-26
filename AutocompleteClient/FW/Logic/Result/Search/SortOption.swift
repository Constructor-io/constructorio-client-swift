//
//  SortOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

struct SortOption {
    let displayName: String
    let sortBy: String
    let sortOrder: SortOrder
    let status: String
}

enum SortOrder: String {
    case ascending = "ascending"
    case descending = "descending"
}
