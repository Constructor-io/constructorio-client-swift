//
//  CIOAutocompleteResponse+SearchSuggestions.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

extension CIOAutocompleteResponse {
    func getSearchSuggestions() -> [CIOAutocompleteResult]? {
        return self.sections["Search Suggestions"]
    }
}
