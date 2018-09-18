//
//  CIOSearchQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute an search query.
 */
public struct CIOSearchQuery: CIORequestData{
    let query: String
    let filters: CIOSearchQueryFilters?
    let page: Int
    let numResultsPerPage: Int
    
    public var url: String{
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString,
                      Constants.SearchQuery.pathString, query)
    }
    
    init(query: String, filters: CIOSearchQueryFilters? = nil, page: Int = 1, numResultsPerPage: Int = 20) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.filters = filters
        self.page = page
        self.numResultsPerPage = numResultsPerPage
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(page: self.page)
        requestBuilder.set(numResultsPerPage: self.numResultsPerPage)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
    }
}
