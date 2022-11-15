//
//  CIOBrowseResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the browse data response from the server.
 */
public struct CIOBrowseResponse {
    /**
     List of facets returned for the result set
     */
    public let facets: [CIOFilterFacet]

    /**
     List of groups (categories) returned for the result set
     */
    public let groups: [CIOFilterGroup]

    /**
     List of results returned for the browse query
     */
    public let results: [CIOResult]

    /**
     List of sorting options
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
     Collection of the result if browsing collection_id
     */
    public let collection: CIOCollectionData?

    /**
     Sources of the result set
     */
    public let resultSources: CIOResultSources?
}
