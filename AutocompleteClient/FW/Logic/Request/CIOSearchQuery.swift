//
//  CIOSearchQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the necessary and additional parameters required to execute a search query.
*/
public struct CIOSearchQuery: CIORequestData {

    public let query: String
    public let page: Int
    public let section: String
    public let filters: SearchFilters?
    public let sortOption: CIOSortOption?

    func url(with baseURL: String) -> String {
        return String(format: "%@/search/%@", baseURL, query)
    }

    public init(query: String, filters: SearchFilters? = nil, sortOption: CIOSortOption? = nil, page: Int = 1, section: String? = nil) {
        self.query = query.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.filters = filters
        self.page = page
        self.section = section != nil ? section! : Constants.SearchQuery.defaultSectionName
        self.sortOption = sortOption
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(page: self.page)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
        requestBuilder.set(searchSection: self.section)
        requestBuilder.set(sortOption: self.sortOption)
    }
}
