//
//  CIOBrowseFacetOptionsQuery.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a browse facet options query.
 */
public struct CIOBrowseFacetOptionsQuery: CIORequestData {
    /**
     Name of the facet whose options to return
     */
    public let facetName: String

    /**
     Whether or not to return hidden facets
     */
    public let showHiddenFacets: Bool?

    func url(with baseURL: String) -> String {
        return String(format: Constants.BrowseFacetOptionsQuery.format, baseURL)
    }

    /**
     Create a Browse facet options request query object

     - Parameters:
        - facetName: Name of the facet whose options to return
        - showHiddenFacets: Whether or not to return hidden facets

     ### Usage Example: ###
     ```
     let browseFacetsQuery = CIOBrowseFacetOptionsQuery(facetName: "price", showHiddenFacets: true)
     ```
     */
    public init(facetName: String, showHiddenFacets: Bool? = nil) {
        self.facetName = facetName
        self.showHiddenFacets = showHiddenFacets
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(facetName: self.facetName)

        if self.showHiddenFacets != nil {
            requestBuilder.set(showHiddenFacets: self.showHiddenFacets!)
        }
    }
}
