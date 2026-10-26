//
//  CIOTrackSortOption.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the sort that a user had applied on a results page, sent when tracking results loaded.
 */
public struct CIOTrackSortOption {
    /**
     The field that the user had sorted by. Must be between 1 and 250 characters, the endpoint rejects other values
     */
    public let sortBy: String?

    /**
     The order of sorting, either `ascending` or `descending`
     */
    public let sortOrder: CIOSortOrder?

    /**
     Create a track sort option.

     - Parameters:
        - sortBy: The field that the user had sorted by
        - sortOrder: The order of sorting
     */
    public init(sortBy: String? = nil, sortOrder: CIOSortOrder? = nil) {
        self.sortBy = sortBy
        self.sortOrder = sortOrder
    }
}
