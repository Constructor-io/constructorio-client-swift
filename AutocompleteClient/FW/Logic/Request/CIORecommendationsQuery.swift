//
//  CIORecommendationsQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
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

    func url(with baseURL: String) -> String {
        return String(format: Constants.RecommendationsQuery.format, baseURL, podID)
    }

    /**
     Create a Recommendations request query object
     
     - Parameters:
        - podID: The pod ID
        - itemID: The item id to retrieve recommendations for (strategy specific)
        - term: The term to use to refine results (strategy specific)
        - filters: The filters used to refine results
        - numResults: The number of results to return
        - section: The section to return results from

     ### Usage Example: ###
     ```
     let recommendationsQuery = CIORecommendationsQuery(podID: "pod_name", itemID: "item_id", numResults: 5, section: "Products")
     ```
     */
    public init(podID: String, itemID: String? = nil, term: String? = nil, filters: CIOQueryFilters? = nil, numResults: Int? = nil, section: String? = nil) {
        self.podID = podID
        self.filters = filters
        self.numResults = numResults != nil ? numResults! : Constants.RecommendationsQuery.defaultNumResults
        self.section = section != nil ? section! : Constants.RecommendationsQuery.defaultSectionName
        self.itemID = itemID
        self.term = term
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(itemID: self.itemID)
        requestBuilder.set(term: self.term)
        requestBuilder.set(searchSection: self.section)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
    }
}
