//
//  CIOAutocompleteQuery.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
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
     The number of results to return for each section
     */
    let numResultsForSection: [String: Int]?

    /**
     The filters used to refine results
     */
    let filters: CIOQueryFilters?

    /**
     The filters to only apply to specific sections
     */
    let sectionFilters: [String: CIOQueryFilters]?

    /**
     The list of hidden metadata fields to return
     */
    public let hiddenFields: [String]?

    /**
     The variation map to use with the result set
     */
    var variationsMap: CIOQueryVariationsMap?

    func url(with baseURL: String) -> String {
        return String(format: Constants.AutocompleteQuery.format, baseURL, query)
    }

    /**
     Create an Autocomplete request query object
        
     - Parameters:
        - query: The user typed query to return results for
        - numResults: The number of results to return
        - numResultsForSection: The number of results to return for each section
        - filters: The filters used to refine results
        - sectionFilters: The filters to only apply to specific sections
        - hiddenFields: The list of hidden metadata fields to return
     
     ### Usage Example: ###
     ```
     let autocompleteQuery = CIOAutocompleteQuery(query: "apple", numResults: 5, numResultsForSection: ["Products": 6, "Search Suggestions": 8], hiddenFields: ["price_CA", "currency_CA"])
     ```
     */
    public init(query: String, filters: CIOQueryFilters? = nil, sectionFilters: [String: CIOQueryFilters]? = nil, numResults: Int? = nil, numResultsForSection: [String: Int]? = nil, hiddenFields: [String]? = nil, variationsMap: CIOQueryVariationsMap? = nil) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.numResults = numResults
        self.numResultsForSection = numResultsForSection
        self.filters = filters
        self.sectionFilters = sectionFilters
        self.hiddenFields = hiddenFields
        self.variationsMap = variationsMap
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(numResultsForSection: self.numResultsForSection)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(sectionFilters: self.sectionFilters)
        requestBuilder.set(hiddenFields: self.hiddenFields)
        requestBuilder.set(variationsMap: self.variationsMap)
    }
}
