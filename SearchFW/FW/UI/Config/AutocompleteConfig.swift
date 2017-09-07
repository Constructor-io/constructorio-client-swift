//
//  AutocompleteConfig.swift
//  SearchFW
//9/6/17.
//  Copyright © 2017 xd. All rights reserved.
//

import Foundation

public struct AutocompleteConfig {

    public var numResults: Int?
    public var numResultsForSection: [String: Int]?

    public init(numResults: Int? = nil, numResultsForSection: [String: Int]? = nil) {
        self.numResults = numResults
        self.numResultsForSection = numResultsForSection
    }
}
