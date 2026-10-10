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

/**
 Values that can be set per pod on a recommendation page request. Each value replaces (is not merged with) the page-wide value for that pod.
 */
public struct CIORecommendationPagePodOverride {
    /**
     The number of results to return
     */
    public let numResults: Int?

    /**
     The filters used to refine results
     */
    public let filters: CIOQueryFilters?

    /**
     Whether results must match "all", "any" or "none" of each filter's values, keyed by filter name
     */
    public let filterMatchTypes: [String: String]?

    /**
     The list of hidden metadata fields to return
     */
    public let hiddenFields: [String]?

    /**
     The pre filter expression used to refine results (JSON string)
     */
    public let preFilterExpression: String?

    /**
     The variation map to use with the result set
     */
    public let variationsMap: CIOQueryVariationsMap?

    /**
     The format options used to refine the result groups
     */
    public let fmtOptions: [FmtOption]?

    /**
     Create a per-pod override

     - Parameters:
        - numResults: The number of results to return
        - filters: The filters used to refine results
        - filterMatchTypes: Whether results must match "all", "any" or "none" of each filter's values
        - hiddenFields: The list of hidden metadata fields to return
        - preFilterExpression: The pre filter expression used to refine results
        - variationsMap: The variation map to use with the result set
        - fmtOptions: The format options used to refine the result groups
     */
    public init(numResults: Int? = nil, filters: CIOQueryFilters? = nil, filterMatchTypes: [String: String]? = nil, hiddenFields: [String]? = nil, preFilterExpression: String? = nil, variationsMap: CIOQueryVariationsMap? = nil, fmtOptions: [FmtOption]? = nil) {
        self.numResults = numResults
        self.filters = filters
        self.filterMatchTypes = filterMatchTypes
        self.hiddenFields = hiddenFields
        self.preFilterExpression = preFilterExpression
        self.variationsMap = variationsMap
        self.fmtOptions = fmtOptions
    }

    // Uses the same setters as CIORecommendationsQuery, so values encode exactly as they do for a pod request
    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        self.filterMatchTypes?.forEach {
            requestBuilder.queryItems.add(URLQueryItem(name: Constants.RecommendationPageQuery.filterMatchTypeKey($0.key), value: $0.value))
        }
        requestBuilder.set(hiddenFields: self.hiddenFields)
        requestBuilder.set(fmtOptions: self.fmtOptions)
        requestBuilder.set(preFilterExpression: self.preFilterExpression)
        requestBuilder.set(variationsMap: self.variationsMap)
    }
}

/**
 Struct encapsulating the parameters required to retrieve the results of every pod on a recommendation page.
 */
public struct CIORecommendationPageQuery: CIORequestData {
    /**
     The page ID
     */
    public let pageID: String

    /**
     The item id to retrieve recommendations for (item-based pods)
     */
    public let itemID: String?

    /**
     The item variation id to retrieve recommendations for (item-based pods)
     */
    public let variationID: String?

    /**
     The term to use to refine results (term-based pods)
     */
    public let term: String?

    /**
     The section to return results from
     */
    public let section: String

    /**
     Page-wide values for the parameters that can also be set per pod
     */
    public let shared: CIORecommendationPagePodOverride

    /**
     Per-pod values keyed by pod ID. Each replaces (is not merged with) the page-wide value for that pod.
     */
    public let podOverrides: [String: CIORecommendationPagePodOverride]?

    func url(with baseURL: String) -> String {
        return String(format: Constants.RecommendationPageQuery.format, baseURL, pageID)
    }

    /**
     Create a Recommendation Page request query object

     - Parameters:
        - pageID: The page ID
        - itemID: The item id to retrieve recommendations for (item-based pods)
        - variationID: The item variation id to retrieve recommendations for (item-based pods)
        - term: The term to use to refine results (term-based pods)
        - section: The section to return results from
        - shared: Page-wide values for the parameters that can also be set per pod
        - podOverrides: Per-pod values keyed by pod ID

     ### Usage Example: ###
     ```
     let query = CIORecommendationPageQuery(
        pageID: "pdp_b2c",
        itemID: "item_id",
        shared: CIORecommendationPagePodOverride(numResults: 10),
        podOverrides: ["complete_the_look": CIORecommendationPagePodOverride(numResults: 8)]
     )
     ```
     */
    public init(pageID: String, itemID: String? = nil, variationID: String? = nil, term: String? = nil, section: String? = nil, shared: CIORecommendationPagePodOverride = CIORecommendationPagePodOverride(), podOverrides: [String: CIORecommendationPagePodOverride]? = nil) {
        self.pageID = pageID
        self.itemID = itemID
        self.variationID = variationID
        self.term = term
        self.section = section ?? Constants.RecommendationsQuery.defaultSectionName
        self.shared = shared
        self.podOverrides = podOverrides
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(itemID: self.itemID)
        requestBuilder.set(variationID: self.variationID)
        requestBuilder.set(term: self.term)
        requestBuilder.set(searchSection: self.section)
        self.shared.decorateRequest(requestBuilder: requestBuilder)

        self.podOverrides?.forEach { podID, override in
            // Encode the override with a scratch builder, then nest each parameter under pod_overrides[<pod id>]
            let overrideBuilder = RequestBuilder(apiKey: "")
            override.decorateRequest(requestBuilder: overrideBuilder)
            let prefix = Constants.RecommendationPageQuery.podOverridesKey(podID)

            for item in overrideBuilder.queryItems.all() where item.name != Constants.Query.apiKey {
                requestBuilder.queryItems.add(URLQueryItem(name: CIORecommendationPageQuery.nest(name: item.name, under: prefix), value: item.value))
            }
        }
    }

    // "filters[color]" -> "<prefix>[filters][color]", "num_results" -> "<prefix>[num_results]"
    static func nest(name: String, under prefix: String) -> String {
        guard let bracketIndex = name.firstIndex(of: "[") else {
            return "\(prefix)[\(name)]"
        }

        return "\(prefix)[\(name[..<bracketIndex])]\(name[bracketIndex...])"
    }
}
