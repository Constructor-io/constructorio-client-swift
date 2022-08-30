//
//  CIORecommendationsQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
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
     Creata a Recommendations request query builder
     
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
     Build the request object with all of the provided data
     
     ### Usage Example: ###
     ```
     let query = CIORecommendationsQueryBuilder(query: "blue")
        .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
        .setItemID("ITEM_123_456")
        .setNumResults(10)
        .setSection("Products")
        .build()

     constructor.recommendations(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIORecommendationsQuery {
        return CIORecommendationsQuery(podID: podID, itemID: itemID, term: term, filters: filters, numResults: numResults, section: section)
    }
}
