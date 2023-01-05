//
//  CIOAutocompleteQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating a autocomplete query
 */
public class CIOAutocompleteQueryBuilder {

    /**
     The user typed query to return results for
     */
    let query: String

    /**
     The number of results to return
     */
    var numResults: Int?

    /**
     The section to return results from
     */
    var numResultsForSection: [String: Int]?

    /**
     The filters used to refine results
     */
    var filters: CIOQueryFilters?

    /**
     The list of hidden metadata fields to return
     */
    var hiddenFields: [String]?

    /**
     The variation map to use with the result set
     */
    var variationsMap: CIOQueryVariationsMap?

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
     Add a variations map to return per variation
     */
    public func setVariationsMap(_ variationsMap: CIOQueryVariationsMap) -> CIOAutocompleteQueryBuilder {
        self.variationsMap = variationsMap
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
        return CIOAutocompleteQuery(query: query, filters: filters, numResults: numResults, numResultsForSection: numResultsForSection, hiddenFields: hiddenFields, variationsMap: variationsMap)
    }
}
