//
//  SortOption.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct SortOption {
    public let displayName: String
    public let sortBy: String
    public let sortOrder: SortOrder
    public let status: String
}

public enum SortOrder: String {
    case ascending
    case descending
}
