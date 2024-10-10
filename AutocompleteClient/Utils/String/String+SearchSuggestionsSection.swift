//
//  String+SearchSuggestionsSection.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension String {
    func isSearchSuggestionString() -> Bool {
        return self.lowercased().replacingOccurrences(of: " ", with: "") == "searchsuggestions"
    }
}
