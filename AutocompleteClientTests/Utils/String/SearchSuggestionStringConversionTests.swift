//
//  SearchSuggestionStringConversionTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class SearchSuggestionStringConversionTests: XCTestCase {

    func testValidSearchSuggestionString() {
        XCTAssertTrue("SEARCH SuggestionS  ".isSearchSuggestionString())
    }

    func testInvalidSearchSuggestionString() {
        XCTAssertFalse("SEARCH Suggestionz".isSearchSuggestionString())
    }

}
