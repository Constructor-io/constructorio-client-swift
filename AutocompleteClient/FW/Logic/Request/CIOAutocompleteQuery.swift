//
//  CIOAutocompleteQuery.swift
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

    public var url: String {
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

public struct CIOSearchQuery: CIORequestData {

    public let query: String
    public let page: Int
    public let section: String
    public let filters: SearchFilters?
    public let sortOptions: [SortOption]?
    
    public var url: String {
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString,
                      Constants.SearchQuery.pathString, query)
    }

    public init(query: String, filters: SearchFilters? = nil, sortOptions: [SortOption]? = nil, page: Int = 1, section: String = Constants.SearchQuery.defaultSectionName) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.filters = filters
        self.page = page
        self.section = section
        self.sortOptions = sortOptions
    }

    public func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(page: self.page)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(searchSection: self.section)
        requestBuilder.set(sortOptions: self.sortOptions)
    }
}

