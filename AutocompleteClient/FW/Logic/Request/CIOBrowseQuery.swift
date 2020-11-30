//
//  CIOBrowseQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a search query.
*/
public struct CIOBrowseQuery: CIORequestData {

    public let filterName: String
    public let filterValue: String
    public let page: Int
    public let perPage: Int
    public let section: String
    public let filters: CIOQueryFilters?
    public let sortOption: CIOSortOption?

    func url(with baseURL: String) -> String {
        return String(format: Constants.BrowseQuery.format, baseURL, filterName, filterValue)
    }

    public init(filterName: String, filterValue:String, filters: CIOQueryFilters? = nil, sortOption: CIOSortOption? = nil, page: Int = 1, perPage: Int = 30, section: String? = nil) {
        self.filterName = filterName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.filterValue = filterValue.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.filters = filters
        self.page = page
        self.perPage = perPage
        self.section = section != nil ? section! : Constants.SearchQuery.defaultSectionName
        self.sortOption = sortOption
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(page: self.page)
        requestBuilder.set(perPage: self.perPage)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(searchSection: self.section)
        requestBuilder.set(sortOption: self.sortOption)
    }
}
