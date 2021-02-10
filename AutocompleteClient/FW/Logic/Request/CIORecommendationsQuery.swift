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

    public let podId: String
    public let section: String
    public let numResults: Int?
    public let itemId: String?
    public let term: String?
    public let filters: CIOQueryFilters?

    func url(with baseURL: String) -> String {
        return String(format: Constants.RecommendationsQuery.format, baseURL, podId)
    }

    public init(podId: String, itemId: String? = nil, term: String? = nil, filters: CIOQueryFilters? = nil, numResults: Int = 5, section: String? = nil) {
        self.podId = podId
        self.filters = filters
        self.numResults = numResults
        self.section = section != nil ? section! : Constants.RecommendationsQuery.defaultSectionName
        self.itemId = itemId
        self.term = term
    }

    func decorateRequest(requestBuilder: RequestBuilder) {
        requestBuilder.set(numResults: self.numResults)
        requestBuilder.set(itemId: self.itemId)
        requestBuilder.set(term: self.term)
        requestBuilder.set(searchSection: self.section)
        requestBuilder.set(groupFilter: self.filters?.groupFilter)
        requestBuilder.set(facetFilters: self.filters?.facetFilters)
    }
}
