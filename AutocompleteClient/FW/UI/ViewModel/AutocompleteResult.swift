//
//  AutocompleteResult.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

class AutocompleteResult {
    let query: CIOAutocompleteQuery
    var response: CIOAutocompleteResponse?
    let timestamp: TimeInterval

    init(query: CIOAutocompleteQuery, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.query = query
        self.timestamp = timestamp
    }

    func isInitiatedAfter(result: AutocompleteResult) -> Bool {
        return self.timestamp > result.timestamp
    }
}
