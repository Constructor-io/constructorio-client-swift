//
//  CIOBrowseFacetsQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an browse facets query.
 */
public class CIOBrowseFacetsQueryBuilder {
    
    /**
     The page of results to request (can't be used with offset)
     */
    var page: Int?

    /**
     The offset of results to request (can't be used with page)
     */
    var offset: Int?
    
    /**
     The number of results per page to return
     */
    var perPage: Int?

    /**
     Whether or not to return hidden facets
     */
    var showHiddenFacets: Bool?

    /**
     Creata a Browse request query builder
     */
    public init() {
    }

    /**
     Add a page number
     */
    public func setPage(_ page: Int) -> CIOBrowseFacetsQueryBuilder {
        self.page = page
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setPerPage(_ perPage: Int) -> CIOBrowseFacetsQueryBuilder {
        self.perPage = perPage
        return self
    }

    /**
     Add a bool indicating whether or not to return hidden facets
     */
    public func setShowHiddenFacets(_ showHiddenFacets: Bool) -> CIOBrowseFacetsQueryBuilder {
        self.showHiddenFacets = showHiddenFacets
        return self
    }


    /**
     Add a offset of results to return
     */
    public func setOffset(_ offset: Int) -> CIOBrowseFacetsQueryBuilder {
        self.offset = offset
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let query = CIOBrowseFacetsQueryBuilder()
        .setPage(2)
        .setPerPage(40)
        .setShowHiddenFacets(true)
        .build()
     
     constructor.browseFacets(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOBrowseFacetsQuery {
        return CIOBrowseFacetsQuery(page: page, offset: offset, perPage: perPage, showHiddenFacets: showHiddenFacets)
    }
}
