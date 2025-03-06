//
//  CIORecommendationsQuery.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a recommendations query.
*/
public struct CIORecommendationsQuery: CIORequestData {
    /**
     The pod ID
     */
    public let podID: String

    /**
     The item id to retrieve recommendations for (strategy specific)
     */
    public let itemID: String?

    /**
     The item variation id to retrieve recommendations for (strategy specific)
     */
    public let variationID: String?

    /**
     The term to use to refine results (strategy specific)
     */
    public let term: String?

    /**
     The filters used to refine results
     */
    public let filters: CIOQueryFilters?

    /**
     The number of results to return
     */
    public let numResults: Int?

    /**
     The section to return results from
     */
    public let section: String

    /**
     The list of hidden metadata fields to return
     */
    public let hiddenFields: [String]?

    /**
     The pre filter expression used to refine results
     Please refer to our docs for the syntax on adding pre filter expressions: https://docs.constructor.com/reference/shared-filter-expressions
     */
    public let preFilterExpression: String?

    func url(with baseURL: String) -> String {
        return String(format: Constants.RecommendationsQuery.format, baseURL, podID)
    }
    
    /**
     The variation map to use with the result set
     Please refer to our docs for the syntax on adding variations mapping: https://docs.constructor.com/reference/shared-variations-mapping
     */
    var variationsMap: CIOQueryVariationsMap?

    /**
     Create a Recommendations request query object
     
     - Parameters:
        - podID: The pod ID
        - itemID: The item id to retrieve recommendations for (strategy specific)
        - variationID: The item variation id to retrieve recommendations for (strategy specific)
        - term: The term to use to refine results (strategy specific)
        - filters: The filters used to refine results
        - numResults: The number of results to return
        - section: The section to return results from
        - hiddenFields: The list of hidden metadata fields to return
        - preFilterExpression: The pre filter expression used to refine results
        - variationsMap: The variation map to use with the result set

     ### Usage Example: ###
     ```
     let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"
     
     let variationsMap = CIOQueryVariationsMap(
        GroupBy: [GroupByOption(name: "Country", field: "data.Country")],
        Values: ["price": ValueOption(aggregation: "min", field: "data.price")],
        Dtype: "array"
     )
     
     let recommendationsQuery = CIORecommendationsQuery(podID: "pod_name", itemID: "item_id", variationID: "variation_id", numResults: 5, section: "Products", hiddenFields: ["price_CA", "currency_CA"], preFilterExpression: preFilterExpression, variationsMap: variationsMap)
     ```
     */
    public init(podID: String, itemID: String? = nil, variationID: String? = nil, term: String? = nil, filters: CIOQueryFilters? = nil, numResults: Int? = nil, section: String? = nil, hiddenFields: [String]? = nil, preFilterExpression: String? = nil, variationsMap: CIOQueryVariationsMap? = nil) {
        self.podID = podID
        self.filters = filters
        self.numResults = numResults != nil ? numResults! : Constants.RecommendationsQuery.defaultNumResults
        self.section = section != nil ? section! : Constants.RecommendationsQuery.defaultSectionName
        self.hiddenFields = hiddenFields
        self.itemID = itemID
        self.variationID = variationID
        self.term = term
        self.preFilterExpression = preFilterExpression
        self.variationsMap = variationsMap
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(itemID: self.itemID)
        requestBuilder.set(variationID: self.variationID)
        requestBuilder.set(term: self.term)
        requestBuilder.set(searchSection: self.section)
        requestBuilder.set(hiddenFields: self.hiddenFields)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(preFilterExpression: self.preFilterExpression)
        requestBuilder.set(variationsMap: self.variationsMap)
    }
}
