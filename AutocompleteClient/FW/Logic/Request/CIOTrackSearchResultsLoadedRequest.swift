//
//  CIOTrackSearchResultsLoadedRequest.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that can be passed to constructorIO.trackSearchResultsLoaded() function.
 */
public struct CIOTrackSearchResultsLoadedRequest {

    /**
     The term that the user searched for
     */
    public let searchTerm: String

    /**
     The number of search results returned in total. Must be 0 or greater, the endpoint rejects other values
     */
    public let resultCount: Int

    /**
     The list of items returned in the search
     */
    public let items: [CIOItem]?

    /**
     Identifier of result set
     */
    public let resultID: String?

    /**
     Additional custom analytics tags to be sent with the event. Merged with the default analytics tags
     */
    public let analyticsTags: [String: String]?

    /**
     The section of the index to use (defaults to the configured default section, or "Products")
     */
    public let section: String?

    /**
     The sort the user had applied on the results page
     */
    public let sortOption: CIOTrackSortOption?

    /**
     Filters that the user had selected on the results page, keyed by facet name with the selected options as values
     */
    public let selectedFilters: [String: [String]]?

    /**
     Current page of results. Must be 0 or greater, the endpoint rejects other values. Pass either `resultPage` or `resultOffset`, not both
     */
    public let resultPage: Int?

    /**
     Current offset of results, used on scrolling sites. Must be 0 or greater, the endpoint rejects other values. Pass either `resultPage` or `resultOffset`, not both
     */
    public let resultOffset: Int?

    /**
     Create a search results loaded request

     - Parameters:
        - searchTerm: The term that the user searched for
        - resultCount: The number of search results returned in total
        - items: The list of items returned in the search
        - resultID: Identifier of result set
        - analyticsTags: Additional custom analytics tags to be sent with the event
        - section: The section of the index to use
        - sortOption: The sort the user had applied on the results page
        - selectedFilters: Filters that the user had selected on the results page
        - resultPage: Current page of results
        - resultOffset: Current offset of results
     */
    public init(searchTerm: String, resultCount: Int, items: [CIOItem]? = nil, resultID: String? = nil, analyticsTags: [String: String]? = nil, section: String? = nil, sortOption: CIOTrackSortOption? = nil, selectedFilters: [String: [String]]? = nil, resultPage: Int? = nil, resultOffset: Int? = nil) {
        self.searchTerm = searchTerm
        self.resultCount = resultCount
        self.items = items
        self.resultID = resultID
        self.analyticsTags = analyticsTags
        self.section = section
        self.sortOption = sortOption
        self.selectedFilters = selectedFilters
        self.resultPage = resultPage
        self.resultOffset = resultOffset
    }
}
