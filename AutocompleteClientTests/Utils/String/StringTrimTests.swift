//
//  StringTrimTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class StringTrimTests: XCTestCase {

    func testStrinTrimRemovedTrailingSpaces() {
        let original = "abc   "
        XCTAssertEqual(original.trim(), "abc")
    }

}
