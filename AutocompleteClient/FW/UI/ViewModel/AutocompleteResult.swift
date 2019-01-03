//
//  AutocompleteResult.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class AutocompleteResult {
    let query: CIOAutocompleteQuery
    var response: CIOAutocompleteResponse?
    let timestamp: TimeInterval

    public init(query: CIOAutocompleteQuery, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.query = query
        self.timestamp = timestamp
    }

    public func isInitiatedAfter(result: AutocompleteResult) -> Bool {
        return self.timestamp > result.timestamp
    }
}
