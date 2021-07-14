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
    /**
     The user typed query to return results for
     */
    let query: String

    /**
     The number of results to return
     */
    let numResults: Int?

    /**
     The section to return results from
     */
    let numResultsForSection: [String: Int]?

    /**
     The filters used to refine results
     */
    let filters: CIOQueryFilters?

    func url(with baseURL: String) -> String {
        return String(format: Constants.AutocompleteQuery.format, baseURL, query)
    }

    /**
     Create an Autocomplete request query object
        
     - Parameters:
        - query: The user typed query to return results for
        - numResults: The number of results to return
        - numresultsForSection: The section to return results from
        - filters: The filters used to refine results
     
     ### Usage Example: ###
     ```
     let autocompleteQuery = CIOAutocompleteQuery(query: "apple", numResults: 5, numResultsForSection: ["Products": 6, "Search Suggestions": 8])
     ```
     */
    public init(query: String, filters: CIOQueryFilters? = nil, numResults: Int? = nil, numResultsForSection: [String: Int]? = nil) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.numResults = numResults
        self.numResultsForSection = numResultsForSection
        self.filters = filters
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(numResultsForSection: self.numResultsForSection)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
    }
}
