//
//  CIOSearchQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an search query.
 */
public class CIOSearchQueryBuilder {

    /**
     The user typed query to return results for
     */
    let query: String

    /**
     The filters used to refine results
     */
    var filters: CIOQueryFilters?

    /**
     The page number of the results
     */
    var page: Int?

    /**
     The number of results per page to return
     */
    var perPage: Int?

    /**
     The sort method/order for results
     */
    var sortOption: CIOSortOption?

    /**
     The section to return results from
     */
    var section: String?

    /**
     The list of hidden metadata fields to return
     */
    var hiddenFields: [String]?

    /**
     The list of hidden facets to return
     */
    var hiddenFacets: [String]?

    /**
     The variation map to use with the result set
     */
    var variationsMap: CIOQueryVariationsMap?

    /**
     The sort method/order for groups
     */
    var groupsSortOption: CIOGroupsSortOption?

    /**
     Create a Search request query builder
     
     - Parameters:
        - query: The user typed query to return results for
     */
    public init(query: String) {
        self.query = query
    }

    /**
     Add additional filters
     */
    public func setFilters(_ filters: CIOQueryFilters) -> CIOSearchQueryBuilder {
        self.filters = filters
        return self
    }

    /**
     Add a sort option
     */
    public func setSortOption(_ sortOption: CIOSortOption) -> CIOSearchQueryBuilder {
        self.sortOption = sortOption
        return self
    }

    /**
     Add a page number
     */
    public func setPage(_ page: Int) -> CIOSearchQueryBuilder {
        self.page = page
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setPerPage(_ perPage: Int) -> CIOSearchQueryBuilder {
        self.perPage = perPage
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setSection(_ section: String) -> CIOSearchQueryBuilder {
        self.section = section
        return self
    }

    /**
     Add a list of hidden metadata fields to return
     */
    public func setHiddenFields(_ hiddenFields: [String]) -> CIOSearchQueryBuilder {
        self.hiddenFields = hiddenFields
        return self
    }

    /**
     Add a list of hidden facets to return
     */
    public func setHiddenFacets(_ hiddenFacets: [String]) -> CIOSearchQueryBuilder {
        self.hiddenFacets = hiddenFacets
        return self
    }

    /**
     Add a groups sort option
     */
    public func setGroupsSortOption(_ groupsSortOption: CIOGroupsSortOption) -> CIOSearchQueryBuilder {
        self.groupsSortOption = groupsSortOption
        return self
    }

    /**
     Add a variations map to return per variation
     */
    public func setVariationsMap(_ variationsMap: CIOQueryVariationsMap) -> CIOSearchQueryBuilder {
        self.variationsMap = variationsMap
        return self
    }

    /**
     Build the request object with all of the provided data
     
     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]
            
     
     let query = CIOSearchQueryBuilder(query: "blue")
        .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
        .setPage(2)
        .setPerPage(40)
        .setSection("Products")
        .setHiddenFields(["hidden_price_field", "color_swatches"])
        .setHiddenFacets(["hidden_facet"])
        .build()
     
     constructor.search(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOSearchQuery {
        return CIOSearchQuery(query: query, filters: filters, sortOption: sortOption, page: page, perPage: perPage, section: section, hiddenFields: hiddenFields, hiddenFacets: hiddenFacets, groupsSortOption: groupsSortOption, variationsMap: variationsMap)
    }
}
