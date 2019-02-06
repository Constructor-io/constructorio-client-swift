//
//  String+SearchSuggestionsSection.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

public extension String {
    public func isSearchSuggestionString() -> Bool {
        return self.lowercased().replacingOccurrences(of: " ", with: "") == "searchsuggestions"
    }

}
