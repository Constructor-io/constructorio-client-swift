//
//  CIOQuery.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public protocol CIOQuery {
    var query: String { get }
}

/**
 Struct encapsulating the necessary and additional parameters required to execute an autocomplete query.
 */
public struct CIOAutocompleteQuery: CIOQuery {
    public let query: String
    public let numResults: Int?
    public let numResultsForSection: [String: Int]?

    public init(query: String, numResults: Int? = nil, numResultsForSection: [String: Int]? = nil) {
        self.query = query
        self.numResults = numResults
        self.numResultsForSection = numResultsForSection
    }
}

/// Not used yet.
struct CIOSearchQuery: CIOQuery {
    let query: String
    let page: Int
    let numResultsPerPage: Int
    let numResultsPerPageForSection: [String: Int]?

    init(query: String, page: Int = 1, numResultsPerPage: Int = 20, numResultsPerPageForSection: [String: Int]? = nil) {
        self.query = query
        self.page = page
        self.numResultsPerPage = numResultsPerPage
        self.numResultsPerPageForSection = numResultsPerPageForSection
    }
}
