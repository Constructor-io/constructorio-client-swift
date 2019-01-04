//
//  AutocompleteResultCountTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
//

import XCTest
import ConstructorAutocomplete

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
