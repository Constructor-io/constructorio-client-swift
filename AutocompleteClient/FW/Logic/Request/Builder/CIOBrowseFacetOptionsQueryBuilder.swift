//
//  CIOBrowseFacetOptionsQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an browse facet options query.
 */
public class CIOBrowseFacetOptionsQueryBuilder {
    
    /**
     The name of the facet whose options to return
     */
    var facetName: String
    
    /**
     Whether or not to return hidden facets
     */
    var showHiddenFacets: Bool?

    /**
     Create a Browse facet options request query builder
     */
    public init(facetName: String) {
        self.facetName = facetName
    }
    
    /**
     Add a bool indicating whether or not to return hidden facets
     */
    public func setShowHiddenFacets(_ showHiddenFacets: Bool) -> CIOBrowseFacetOptionsQueryBuilder {
        self.showHiddenFacets = showHiddenFacets
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let query = CIOBrowseFacetOptionsQueryBuilder(facetName: "price")
        .setShowHiddenFacets(true)
        .build()
     
     constructor.browseFacetOptions(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOBrowseFacetOptionsQuery {
        return CIOBrowseFacetOptionsQuery(facetName: facetName, showHiddenFacets: showHiddenFacets)
    }
}
