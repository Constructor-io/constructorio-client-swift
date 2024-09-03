//
//  AutocompleteResult.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

public class AutocompleteResult {
    public let query: CIOAutocompleteQuery
    public var response: CIOAutocompleteResponse?
    public let timestamp: TimeInterval

    public init(query: CIOAutocompleteQuery, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.query = query
        self.timestamp = timestamp
    }

    public func isInitiatedAfter(result: AutocompleteResult) -> Bool {
        return self.timestamp > result.timestamp
    }
}
