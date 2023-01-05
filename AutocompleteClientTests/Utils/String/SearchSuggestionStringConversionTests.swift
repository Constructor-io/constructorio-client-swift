//
//  SearchSuggestionStringConversionTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class SearchSuggestionStringConversionTests: XCTestCase {

    func testValidSearchSuggestionString() {
        XCTAssertTrue("SEARCH SuggestionS  ".isSearchSuggestionString())
    }

    func testInvalidSearchSuggestionString() {
        XCTAssertFalse("SEARCH Suggestionz".isSearchSuggestionString())
    }

}
