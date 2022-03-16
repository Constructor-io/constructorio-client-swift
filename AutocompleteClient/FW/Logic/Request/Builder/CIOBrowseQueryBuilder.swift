//
//  CIOSearchQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class CIOBrowseQueryBuilder {

    /**
     The primary filter name that the user browsed for
     */
    public let filterName: String

    /**
     The primary filter value that the user browsed for
     */
    public let filterValue: String

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
     Creata a Browse request query builder
     
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
     Add a list of hidden fields to return
     */
    public func setHiddenFields(_ hiddenFields: [String]) -> CIOBrowseQueryBuilder {
        self.hiddenFields = hiddenFields
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]
     
     let query = CIOBrowseQueryBuilder(filterName: "potato", filterValue: "russet")
        .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
        .setPage(2)
        .setPerPage(40)
        .setSection("Products")
        .setHiddenFields(["hidden_price_field", "color_swatches"])
        .build()
     
     constructor.browse(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOBrowseQuery {
        return CIOBrowseQuery(filterName: filterName, filterValue: filterValue, filters: filters, sortOption: sortOption, page: page, perPage: perPage, section: section, hiddenFields: hiddenFields)
    }
}
