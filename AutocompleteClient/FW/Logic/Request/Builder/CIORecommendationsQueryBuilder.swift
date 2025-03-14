//
//  CIORecommendationsQueryBuilder.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating a recommendations query
 */
public class CIORecommendationsQueryBuilder {

    /**
     The pod ID
     */
    let podID: String

    /**
     The item id to retrieve recommendations for (strategy specific)
     */
    var itemID: String?

    /**
     The item variation id to retrieve recommendations for (strategy specific)
     */
    var variationID: String?

    /**
     The term to use to refine results (strategy specific)
     */
    var term: String?

    /**
     The filters used to refine results 
     */
    var filters: CIOQueryFilters?

    /**
     The number of results to return
     */
    var numResults: Int?

    /**
     The section to return results from
     */
    var section: String?

    /**
     The list of hidden metadata fields to return
     */
    var hiddenFields: [String]?

    /**
     The pre filter expression used to refine results
     Please refer to our docs for the syntax on adding pre filter expressions: https://docs.constructor.com/reference/shared-filter-expressions
    */
    var preFilterExpression: String?
    
    /**
     The variation map to use with the result set
     */
    var variationsMap: CIOQueryVariationsMap?

    /**
     Create a Recommendations request query builder

     - Parameters:
        - podID: The pod ID
     */
    public init(podID: String) {
        self.podID = podID
    }

    /**
     Add an item id to retrieve recommendations for (strategy specific)
     */
    public func setItemID(_ itemID: String) -> CIORecommendationsQueryBuilder {
        self.itemID = itemID
        return self
    }

    /**
     Add an item variation id to retrieve recommendations for (strategy specific)
     */
    public func setVariationID(_ variationID: String) -> CIORecommendationsQueryBuilder {
        self.variationID = variationID
        return self
    }

    /**
     Add a term to refine results (strategy specific)
     */
    public func setTerm(_ term: String) -> CIORecommendationsQueryBuilder {
        self.term = term
        return self
    }

    /**
     Add the number of results to return
     */
    public func setNumResults(_ numResults: Int) -> CIORecommendationsQueryBuilder {
        self.numResults = numResults
        return self
    }

    /**
     Add additional filters
     */
    public func setFilters(_ filters: CIOQueryFilters) -> CIORecommendationsQueryBuilder {
        self.filters = filters
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setSection(_ section: String) -> CIORecommendationsQueryBuilder {
        self.section = section
        return self
    }

    /**
     Add a list of hidden metadata fields to return
     */
    public func setHiddenFields(_ hiddenFields: [String]) -> CIORecommendationsQueryBuilder {
        self.hiddenFields = hiddenFields
        return self
    }

    /**
     Add the pre filter expression
     */
    public func setPreFilterExpression(_ preFilterExpression: String) -> CIORecommendationsQueryBuilder {
        self.preFilterExpression = preFilterExpression
        return self
    }
    
    /**
     Add a variations map to return per variation
     */
    public func setVariationsMap(_ variationsMap: CIOQueryVariationsMap) -> CIORecommendationsQueryBuilder {
        self.variationsMap = variationsMap
        return self
    }

    /**
     Build the request object with all of the provided data
     
     ### Usage Example: ###
     ```
     let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"

     let query = CIORecommendationsQueryBuilder(query: "blue")
        .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
        .setItemID("ITEM_123_456")
        .setVariationID("ITEM_123_456_red")
        .setNumResults(10)
        .setSection("Products")
        .setHiddenFields(["hidden_price_field", "color_swatches"])
        .setPreFilterExpression(preFilterExpression)
        .build()

     constructor.recommendations(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIORecommendationsQuery {
        return CIORecommendationsQuery(podID: podID, itemID: itemID, variationID: variationID, term: term, filters: filters, numResults: numResults, section: section, hiddenFields: hiddenFields, preFilterExpression: preFilterExpression, variationsMap: variationsMap)
    }
}
