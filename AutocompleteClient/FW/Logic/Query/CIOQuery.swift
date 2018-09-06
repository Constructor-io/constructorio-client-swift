//
//  CIOQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute an autocomplete query.
 */
public struct CIOAutocompleteQuery: CIORequestData {
    public let query: String
    public let numResults: Int?
    public let numResultsForSection: [String: Int]?
    
    public var url: String{
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString,
               Constants.AutocompleteQuery.pathString, query)
    }
    
    public init(query: String, numResults: Int? = nil, numResultsForSection: [String: Int]? = nil) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.numResults = numResults
        self.numResultsForSection = numResultsForSection
    }
    
    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(numResultsForSection: self.numResultsForSection)
    }
}

/// Not used yet.
struct CIOSearchQuery{
    let query: String
    let page: Int
    let numResultsPerPage: Int
    let numResultsPerPageForSection: [String: Int]?

    init(query: String, page: Int = 1, numResultsPerPage: Int = 20, numResultsPerPageForSection: [String: Int]? = nil) {
        self.query = query
        self.page = page
        self.numResultsPerPage = numResultsPerPage
        self.numResultsPerPageForSection = numResultsPerPageForSection
    }
}
