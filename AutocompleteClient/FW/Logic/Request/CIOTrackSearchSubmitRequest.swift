//
//  CIOTrackSearchSubmitRequest.swift
//  AutocompleteClient
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the parameters that can be passed to constructorIO.trackSearchSubmit() function.
 */
public struct CIOTrackSearchSubmitRequest {

    /**
     The term that the user searched for
     */
    public let searchTerm: String

    /**
     The current text in the input field
     */
    public let userInput: String

    /**
     The filters applied by the search. Only a group id is supported, i.e. "Pumpkin in Canned Goods"
     */
    public let filters: CIOTrackSearchSubmitFilters?

    /**
     Additional custom analytics tags to be sent with the event. Merged with the default analytics tags
     */
    public let analyticsTags: [String: String]?

    /**
     The section of the index to use (defaults to the configured default section, or "Products")
     */
    public let section: String?

    /**
     Create a search submit request

     - Parameters:
        - searchTerm: The term that the user searched for
        - userInput: The current text in the input field
        - filters: The filters applied by the search
        - analyticsTags: Additional custom analytics tags to be sent with the event
        - section: The section of the index to use
     */
    public init(searchTerm: String, userInput: String, filters: CIOTrackSearchSubmitFilters? = nil, analyticsTags: [String: String]? = nil, section: String? = nil) {
        self.searchTerm = searchTerm
        self.userInput = userInput
        self.filters = filters
        self.analyticsTags = analyticsTags
        self.section = section
    }
}
