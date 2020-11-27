//
//  CIOBrowseResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the search data response from the server.
 */
public struct CIOBrowseResponse {
    public let facets: [CIOFilterFacet]
    public let groups: [CIOFilterGroup]
    public let results: [CIOResult]
    public let sortOptions: [CIOSortOption]
    public let totalNumResults: Int
    public let resultID: String
}
