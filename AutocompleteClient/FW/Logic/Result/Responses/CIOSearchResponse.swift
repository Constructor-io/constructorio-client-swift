//
//  CIOSearchResponse.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
     A list of sorting options
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
     A list of refined content
     */
    public let refinedContent: [CIORefinedContent]

    /**
     Flag to determine if the response is a redirect
     */
    public var isRedirect: Bool {
        return self.redirectInfo != nil
    }

    /**
     Request object used to retrieve the Search Response
     */
    public var request: JSONObject
}
