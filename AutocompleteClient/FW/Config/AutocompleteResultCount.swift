//
<<<<<<< HEAD:AutocompleteClient/FW/Config/AutocompleteResultCount.swift
//  AutocompleteResultCount.swift
=======
//  ResultCount.swift
>>>>>>> 9629388ab390297b07e997cc8e4a18eb93aba86b:AutocompleteClient/FW/Config/AutocompleteResultCount.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public struct AutocompleteResultCount{
    public let numResults: Int?
    public let numResultsForSection: [String: Int]?
    
    public init(numResults: Int) {
        self.numResults = numResults
        self.numResultsForSection = nil
    }
    
    public init(numResultsForSection: [String: Int]) {
        self.numResultsForSection = numResultsForSection
        self.numResults = nil
    }
}
