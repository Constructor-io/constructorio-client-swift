//
//  String+SearchSuggestionsSection.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation

extension String {
    func isSearchSuggestionString() -> Bool {
        return self.lowercased().replacingOccurrences(of: " ", with: "") == "searchsuggestions"
    }
}
