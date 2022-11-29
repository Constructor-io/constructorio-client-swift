//
//  CIOBrowseItemsQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a browse items query.
 */
public struct CIOBrowseItemsQuery: CIORequestData {
    /**
     The list of item ids to request
     */
    public let ids: [String]

    /**
     The filters used to refine results
     */
    public let filters: CIOQueryFilters?

    /**
     The page number of the results
     */
    public let page: Int

    /**
     The number of results per page to return
     */
    public let perPage: Int

    /**
     The sort method/order for results
     */
    public let sortOption: CIOSortOption?

    /**
     The section to return results from
     */
    public let section: String

    /**
     The list of hidden metadata fields to return
     */
    public let hiddenFields: [String]?

    /**
     The list of hidden facet fields to return
     */
    public let hiddenFacets: [String]?
    
    /**
     The variation map to use with the result set
     */
    var variationsMap: CIOQueryVariationsMap?

    /**
     The sort method/order for groups
     */
    public let groupsSortOption: CIOGroupsSortOption?

    func url(with baseURL: String) -> String {
        return String(format: Constants.BrowseItemsQuery.format, baseURL, "items")
    }

    /**
     Create a Browse request query object

     - Parameters:
        - ids: The list of item ids to request
        - filters: The filters used to refine results
        - page: The page number of the results
        - perPage: The number of results per page to return
        - sortOption: The sort method/order for results
        - section: The section to return results from
        - hiddenFields: The list of hidden metadata fields to return
        - hiddenFacets: The list of hidden facest to return
        - groupsSortOption: The sort method/order for groups

     ### Usage Example: ###
     ```
     let facetFilters = [(key: "Nutrition", value: "Organic"),
                         (key: "Nutrition", value: "Natural"),
                         (key: "Brand", value: "Kraft Foods")]

     let browseQuery = CIOBrowseItemsQuery(ids: ["123", "234"], filters: CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters), page: 1, perPage: 30, section: "Products", hiddenFields: ["price_CA", "currency_CA"], hiddenFacets: ["brand", "price_CA"]))
     ```
     */
    public init(ids: [String], filters: CIOQueryFilters? = nil, sortOption: CIOSortOption? = nil, page: Int? = nil, perPage: Int? = nil, section: String? = nil, hiddenFields: [String]? = nil, hiddenFacets: [String]? = nil, groupsSortOption: CIOGroupsSortOption? = nil, variationsMap: CIOQueryVariationsMap? = nil) {
        self.filters = filters
        self.page = page != nil ? page! : Constants.BrowseQuery.defaultPage
        self.perPage = perPage != nil ? perPage! : Constants.BrowseQuery.defaultPerPage
        self.section = section != nil ? section! : Constants.BrowseQuery.defaultSectionName
        self.sortOption = sortOption
        self.hiddenFields = hiddenFields
        self.hiddenFacets = hiddenFacets
        self.variationsMap = variationsMap
        self.groupsSortOption = groupsSortOption
        self.ids = ids
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(page: self.page)
        requestBuilder.set(perPage: self.perPage)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(searchSection: self.section)
        requestBuilder.set(sortOption: self.sortOption)
        requestBuilder.set(hiddenFields: self.hiddenFields)
        requestBuilder.set(hiddenFacets: self.hiddenFacets)
        requestBuilder.set(variationsMap: self.variationsMap)
        requestBuilder.set(groupsSortOption: self.groupsSortOption)
        requestBuilder.set(ids: self.ids)
    }
}
