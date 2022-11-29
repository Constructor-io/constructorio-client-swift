//
//  CIOBrowseItemsQueryBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Request builder for creating an browse items query.
 */
public class CIOBrowseItemsQueryBuilder {

    /**
     The list of item ids to request
     **/
    let ids: [String]

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
     Creata a Browse request query builder
     
     - Parameters:
        - ids - the list of item ids to request
     */
    public init(ids: [String]) {
        self.ids = ids
    }

    /**
     Add additional filters
     */
    public func setFilters(_ filters: CIOQueryFilters) -> CIOBrowseItemsQueryBuilder {
        self.filters = filters
        return self
    }

    /**
     Add a sort option
     */
    public func setSortOption(_ sortOption: CIOSortOption) -> CIOBrowseItemsQueryBuilder {
        self.sortOption = sortOption
        return self
    }

    /**
     Add a page number
     */
    public func setPage(_ page: Int) -> CIOBrowseItemsQueryBuilder {
        self.page = page
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setPerPage(_ perPage: Int) -> CIOBrowseItemsQueryBuilder {
        self.perPage = perPage
        return self
    }

    /**
     Add the number of results to return per page
     */
    public func setSection(_ section: String) -> CIOBrowseItemsQueryBuilder {
        self.section = section
        return self
    }

    /**
     Add a list of hidden metadata fields to return
     */
    public func setHiddenFields(_ hiddenFields: [String]) -> CIOBrowseItemsQueryBuilder {
        self.hiddenFields = hiddenFields
        return self
    }

    /**
     Add a list of hidden facets to return
     */
    public func setHiddenFacets(_ hiddenFacets: [String]) -> CIOBrowseItemsQueryBuilder {
        self.hiddenFacets = hiddenFacets
        return self
    }
    
    /**
     Add a variations map to return per variation
     */
    public func setVariationsMap(_ variationsMap: CIOQueryVariationsMap) -> CIOBrowseItemsQueryBuilder {
        self.variationsMap = variationsMap
        return self
    }

    /**
     Add a groups sort option
     */
    public func setGroupsSortOption(_ groupsSortOption: CIOGroupsSortOption) -> CIOBrowseItemsQueryBuilder {
        self.groupsSortOption = groupsSortOption
        return self
    }

    /**
     Build the request object set all of the provided data
     
     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]
     
     let query = CIOBrowseItemsQueryBuilder(ids: ["123", "123"])
        .setFilters(CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters))
        .setPage(2)
        .setPerPage(40)
        .setSection("Products")
        .setHiddenFields(["hidden_price_field", "color_swatches"])
        .setHiddenFacets(["hidden_facet"])
        .build()
     
     constructor.browseItems(forQuery: query, completionHandler: { ... })
     ```
     */
    public func build() -> CIOBrowseItemsQuery {
        return CIOBrowseItemsQuery(ids: ids, filters: filters, sortOption: sortOption, page: page, perPage: perPage, section: section, hiddenFields: hiddenFields, hiddenFacets: hiddenFacets, groupsSortOption: groupsSortOption, variationsMap: variationsMap)
    }
}
