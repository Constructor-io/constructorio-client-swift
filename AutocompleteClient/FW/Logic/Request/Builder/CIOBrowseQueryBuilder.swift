//
//  CIOBrowseQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an browse query.
 */
public class CIOBrowseQueryBuilder {

    /**
     The primary filter name that the user browsed for
     */
    let filterName: String

    /**
     The primary filter value that the user browsed for
     */
    let filterValue: String

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
     The pre filter expression used to refine results.
     Please refer to our docs for the syntax on adding pre filter expressions: https://docs.constructor.com/reference/configuration-collections
     */
    var preFilterExpression: String?

    /**
     Create a Browse request query builder
     
     - Parameters:
        - filterName: The primary filter name that the user browsed for
        - filterValue: The primary filter value that the user browsed for
     */
    public init(filterName: String, filterValue: String) {
        self.filterName = filterName
        self.filterValue = filterValue
    }

    /**
     Add additional filters
     */
    public func setFilters(_ filters: CIOQueryFilters) -> CIOBrowseQueryBuilder {
        self.filters = filters
        return self
    }

    /**
     Add a sort option
     */
    public func setSortOption(_ sortOption: CIOSortOption) -> CIOBrowseQueryBuilder {
        self.sortOption = sortOption
        return self
    }

    /**
     Add a page number
     */
    public func setPage(_ page: Int) -> CIOBrowseQueryBuilder {
        self.page = page
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setPerPage(_ perPage: Int) -> CIOBrowseQueryBuilder {
        self.perPage = perPage
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setSection(_ section: String) -> CIOBrowseQueryBuilder {
        self.section = section
        return self
    }

    /**
     Add a list of hidden metadata fields to return
     */
    public func setHiddenFields(_ hiddenFields: [String]) -> CIOBrowseQueryBuilder {
        self.hiddenFields = hiddenFields
        return self
    }

    /**
     Add a list of hidden facets to return
     */
    public func setHiddenFacets(_ hiddenFacets: [String]) -> CIOBrowseQueryBuilder {
        self.hiddenFacets = hiddenFacets
        return self
    }

    /**
     Add a variations map to return per variation
     */
    public func setVariationsMap(_ variationsMap: CIOQueryVariationsMap) -> CIOBrowseQueryBuilder {
        self.variationsMap = variationsMap
        return self
    }

    /**
     Add a groups sort option
     */
    public func setGroupsSortOption(_ groupsSortOption: CIOGroupsSortOption) -> CIOBrowseQueryBuilder {
        self.groupsSortOption = groupsSortOption
        return self
    }

    /**
     Add the pre filter expression
     */
    public func setPreFilterExpression(_ preFilterExpression: String) -> CIOBrowseQueryBuilder {
        self.preFilterExpression = preFilterExpression
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]
     
     let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"
     
     let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
        .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
        .setPage(2)
        .setPerPage(40)
        .setSection("Products")
        .setHiddenFields(["hidden_price_field", "color_swatches"])
        .setHiddenFacets(["hidden_facet"])
        .setPreFilterExpression(preFilterExpression)
        .build()
     
     constructor.browse(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOBrowseQuery {
        return CIOBrowseQuery(filterName: filterName, filterValue: filterValue, filters: filters, sortOption: sortOption, page: page, perPage: perPage, section: section, hiddenFields: hiddenFields, hiddenFacets: hiddenFacets, groupsSortOption: groupsSortOption, variationsMap: variationsMap, preFilterExpression: preFilterExpression)
    }
}
