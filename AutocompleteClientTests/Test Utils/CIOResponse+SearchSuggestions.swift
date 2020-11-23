//
//  CIOAutocompleteResponse+SearchSuggestions.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

extension CIOAutocompleteResponse {
    func getSearchSuggestions() -> [CIOAutocompleteResult]? {
        return self.sections["Search Suggestions"]
    }
}
