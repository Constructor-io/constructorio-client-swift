//
//  AutocompleteResultCountTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

class AutocompleteResultCountTests: XCTestCase {

    func testAutocompleteResultCount_NumResultsInitializer() {
        let resultCount = AutocompleteResultCount(numResults: 1)
        XCTAssertNotNil(resultCount.numResults)
        XCTAssertNil(resultCount.numResultsForSection)
    }

    func testAutocompleteResultCount_NumResultsForSectionInitializer() {
        let resultCount = AutocompleteResultCount(numResultsForSection: [:])
        XCTAssertNil(resultCount.numResults)
        XCTAssertNotNil(resultCount.numResultsForSection)
    }

}
