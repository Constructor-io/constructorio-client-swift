//
//  CIOSearchResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the search data response from the server.
 */
public struct CIOSearchResponse {
    public let facets: [CIOFilterFacet]
    public let groups: [CIOGroup]
    public let results: [CIOResult]
    public let redirectInfo: CIOSearchRedirectInfo?
    public let sortOptions: [CIOSortOption]
    public let totalNumResults: Int
    public let resultID: String

    public var isRedirect: Bool {
        return self.redirectInfo != nil
    }
}
