//
//  SearchSuggestionStringConversionTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
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
