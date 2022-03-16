//
//  CIOAutocompleteQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class CIOAutocompleteQueryBuilder {

    /**
     The user typed query to return results for
     */
    public let query: String

    /**
     The number of results to return
     */
    public var numResults: Int?

    /**
     The section to return results from
     */
    public var numResultsForSection: [String: Int]?

    /**
     The filters used to refine results
     */
    public var filters: CIOQueryFilters?

    /**
     The list of hidden metadata fields to return
     */
    public var hiddenFields: [String]?

    /**
     Creata a Autocomplete request query builder
     
     - Parameters:
        - query: The user typed query to return results for
     */
    public init(query: String) {
        self.query = query
    }

    /**
     Add the number of results to return per page
     */
    public func setNumResults(_ numResults: Int) -> CIOAutocompleteQueryBuilder {
        self.numResults = numResults
        return self
    }

    /**
     Add a sort option
     */
    public func setNumResultsForSection(_ numResultsForSection: [String: Int]) -> CIOAutocompleteQueryBuilder {
        self.numResultsForSection = numResultsForSection
        return self
    }

    /**
     Add additional filters
     */
    public func setFilters(_ filters: CIOQueryFilters) -> CIOAutocompleteQueryBuilder {
        self.filters = filters
        return self
    }

    /**
     Add a list of hidden fields to return
     */
    public func setHiddenFields(_ hiddenFields: [String]) -> CIOAutocompleteQueryBuilder {
        self.hiddenFields = hiddenFields
        return self
    }

    /**
     Build the request object with all of the provided data
     
     ### Usage Example: ###
     ```
     let facetFilters = [(key: "availability", value: "US")]
            
     let query = CIOAutocompleteQueryBuilder(query: "blue")
        .setNumResultsForSection([
            "Products": 5,
            "Search Suggestions": 5
        ])
        .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
        .setHiddenFields(["hidden_price_field", "color_swatches"])
        .build()
     
     constructor.autocomplete(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOAutocompleteQuery {
        return CIOAutocompleteQuery(query: query, filters: filters, numResults: numResults, numResultsForSection: numResultsForSection, hiddenFields: hiddenFields)
    }
}
