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
struct CIOAutocompleteQuery: CIORequestData {
    let query: String
    let numResults: Int?
    let numResultsForSection: [String: Int]?

    var url: String {
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString,
               Constants.AutocompleteQuery.pathString, query)
    }

    init(query: String, numResults: Int? = nil, numResultsForSection: [String: Int]? = nil) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.numResults = numResults
        self.numResultsForSection = numResultsForSection
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(numResultsForSection: self.numResultsForSection)
    }
}

struct CIOSearchQuery: CIORequestData {

    let query: String
    let filters: SearchFilters?
    let page: Int
    let section: String

    var url: String {
        return String(format: Constants.Query.queryStringFormat, Constants.Query.baseURLString,
                      Constants.SearchQuery.pathString, query)
    }

    init(query: String, filters: SearchFilters? = nil, page: Int = 1, section: String = Constants.SearchQuery.defaultSectionName) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.filters = filters
        self.page = page
        self.section = section
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(page: self.page)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(searchSection: self.section)
    }
}

