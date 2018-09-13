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
    public let query: String
    public let page: Int
    public let numResultsPerPage: Int

    public var url: String{
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString,
                      Constants.SearchQuery.pathString, query)
    }
    
    init(query: String, page: Int = 1, numResultsPerPage: Int = 20) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.page = page
        self.numResultsPerPage = numResultsPerPage
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResultsPerPage)
    }
}
