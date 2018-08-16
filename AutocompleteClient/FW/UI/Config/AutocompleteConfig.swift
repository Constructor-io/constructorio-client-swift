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

    public init(numResults: Int) {
        self.numResults = numResults
        self.numResultsForSection = nil
    }
    
    public init(numResultsForSection: [String: Int]) {
        self.numResultsForSection = numResultsForSection
        self.numResults = nil
    }
}
