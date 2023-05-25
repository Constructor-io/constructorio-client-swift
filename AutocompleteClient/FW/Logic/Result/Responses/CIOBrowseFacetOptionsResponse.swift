//
//  CIOBrowseFacetOptionsResponse.swift
//  AutocompleteClient
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct representing the browse facet options data response from the server.
 */
public struct CIOBrowseFacetOptionsResponse {
    /**
     List of facets returned
     */
    public let facets: [CIOFilterFacet]

    /**
     Result ID of the result set returned
     */
    public let resultID: String
}
