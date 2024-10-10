//
//  AutocompleteResultCount.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

/**
 Struct encapsulating the result count
 */
public struct AutocompleteResultCount {
    /**
     The total number of results to request for
     */
    public let numResults: Int?

    /**
     The number of results to request for per section
     */
    public let numResultsForSection: [String: Int]?

    /**
     Create a result count object with a set number of results to be returned overall
     
     - Parameters:
        - numResults: Total number of results to be returned

     ### Usage Example: ###
     ```
     let resultCount = AutocompleteResultCount(numResults: 10)
     ```
     */
    public init(numResults: Int) {
        self.numResults = numResults
        self.numResultsForSection = nil
    }

    /**
     Create a result count object with a set number of results to be returned overall
     
     - Parameters:
        - numResultsForSection: Number of results to be returned per section
     
     ### Usage Example: ###
     ```
     let resultCount = AutocompleteResultCount(numResultsForSection: ["Search Suggestions": 3, "Products": 4])
     ```
     */
    public init(numResultsForSection: [String: Int]) {
        self.numResultsForSection = numResultsForSection
        self.numResults = nil
    }
}
