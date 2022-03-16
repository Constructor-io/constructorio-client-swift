//
//  CIOSearchQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class CIOSearchQueryBuilder {

    /**
     The user typed query to return results for
     */
    public let query: String

    /**
     The filters used to refine results
     */
    public var filters: CIOQueryFilters?

    /**
     The page number of the results
     */
    public var page: Int?

    /**
     The number of results per page to return
     */
    public var perPage: Int?

    /**
     The sort method/order for results
     */
    public var sortOption: CIOSortOption?

    /**
     The section to return results from
     */
    public var section: String?

    /**
     The list of hidden metadata fields to return
     */
    public var hiddenFields: [String]?

    /**
     Creata a Search request query builder
     
     - Parameters:
        - query: The user typed query to return results for
     */
    public init(query: String) {
        self.query = query
    }

    /**
     Add additional filters
     */
    public func withFilters(_ filters: CIOQueryFilters) -> CIOSearchQueryBuilder {
        self.filters = filters
        return self
    }

    /**
     Add a sort option
     */
    public func withSortOption(_ sortOption: CIOSortOption) -> CIOSearchQueryBuilder {
        self.sortOption = sortOption
        return self
    }

    /**
     Add a page number
     */
    public func withPage(_ page: Int) -> CIOSearchQueryBuilder {
        self.page = page
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func withPerPage(_ perPage: Int) -> CIOSearchQueryBuilder {
        self.perPage = perPage
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func withSection(_ section: String) -> CIOSearchQueryBuilder {
        self.section = section
        return self
    }

    /**
     Add a list of hidden fields to return
     */
    public func withHiddenFields(_ hiddenFields: [String]) -> CIOSearchQueryBuilder {
        self.hiddenFields = hiddenFields
        return self
    }

    /**
     Build the request object with all of the provided data
     
     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]
     
     let builder = CIOSearchQueryBuilder(query: "blue")
     searchQuery.filters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
     searchQuery.page = 2
     searchQuery.perPage = 50
     
     let searchQuery = builder.build()
     ```
     */
    public func build() -> CIOSearchQuery {
        return CIOSearchQuery(query: query, filters: filters, sortOption: sortOption, page: page, perPage: perPage, section: section, hiddenFields: hiddenFields)
    }
}
