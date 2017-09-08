//
//  Constants.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
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
