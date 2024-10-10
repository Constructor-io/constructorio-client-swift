//
//  CIOBrowseFacetsResponse.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the browse facets data response from the server.
 */
public struct CIOBrowseFacetsResponse {
    /**
     List of facets returned
     */
    public let facets: [CIOFilterFacet]

    /**
     Total number of results for the query
     */
    public let totalNumResults: Int

    /**
     Result ID of the result set returned
     */
    public let resultID: String
}
