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
 Use this struct for tracking events; for sending requests, use `CIOSortOption` instead.
 */
public struct CIOTrackSortOption {
    /**
     The field that the user had sorted by. Must be between 1 and 250 characters, the endpoint rejects other values
     */
    public let sortBy: String

    /**
     The order of sorting, either `ascending` or `descending`
     */
    public let sortOrder: CIOSortOrder

    /**
     Create a track sort option.

     - Parameters:
        - sortBy: The field that the user had sorted by
        - sortOrder: The order of sorting
     */
    public init(sortBy: String, sortOrder: CIOSortOrder) {
        self.sortBy = sortBy
        self.sortOrder = sortOrder
    }

    /**
     Create a track sort option from a `CIOSortOption`, such as one returned in `CIOSearchResponse.sortOptions`

     - Parameters:
        - sortOption: The sort option that the user had applied
     */
    public init(sortOption: CIOSortOption) {
        self.init(sortBy: sortOption.sortBy, sortOrder: sortOption.sortOrder)
    }
}
