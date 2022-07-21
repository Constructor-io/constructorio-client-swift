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
    /**
     List of facets returned for the result set
     */
    public let facets: [CIOFilterFacet]

    /**
     List of groups (categories) returned for the result set
     */
    public let groups: [CIOFilterGroup]

    /**
     List of results returned for the search query
     */
    public let results: [CIOResult]

    /**
     Additional info about the redirect
     */
    public let redirectInfo: CIOSearchRedirectInfo?

    /**
     A list sorting options
     */
    public let sortOptions: [CIOSortOption]

    /**
     Total number of results for the query
     */
    public let totalNumResults: Int

    /**
     Result ID of the result set returned
     */
    public let resultID: String

    /**
     Sources of the result set
     */
    public let resultSources: CIOResultSources?
    
    /**
     Flag to determine if the response is a redirect
     */
    public var isRedirect: Bool {
        return self.redirectInfo != nil
    }
}
