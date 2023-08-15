//
//  CIOBrowseFacetsQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a browse facets query.
 */
public struct CIOBrowseFacetsQuery: CIORequestData {
    /**
     The page of results to request (can't be used with offset)
     */
    public let page: Int?

    /**
     The offset of results to request (can't be used with page)
     */
    public let offset: Int?

    /**
     The number of results per page to return
     */
    public let perPage: Int?

    /**
     Whether or not to return hidden facets
     */
    public let showHiddenFacets: Bool?

    func url(with baseURL: String) -> String {
        return String(format: Constants.BrowseFacetsQuery.format, baseURL)
    }

    /**
     Create a Browse facets request query object

     - Parameters:
        - page: The page number of the results (can't be used with offset)
        - offset: The offset of results to request (can't be used with page)
        - perPage: The number of results per page to return
        - showHiddenFacets: Whether or not to return hidden facets

     ### Usage Example: ###
     ```
     let browseFacetsQuery = CIOBrowseFacetsQuery(page: 2, perPage: 30, showHiddenFacets: true)
     ```
     */
    public init(page: Int? = nil, offset: Int? = nil, perPage: Int? = nil, showHiddenFacets: Bool? = nil) {
        self.page = page
        self.perPage = perPage
        self.offset = offset
        self.showHiddenFacets = showHiddenFacets
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        if self.page != nil {
            requestBuilder.set(page: self.page!)
        }
        if self.perPage != nil {
            requestBuilder.set(perPage: self.perPage!)
        }
        if self.offset != nil {
            requestBuilder.set(offset: self.offset!)
        }
        if self.showHiddenFacets != nil {
            requestBuilder.set(showHiddenFacets: self.showHiddenFacets!)
        }
    }
}
