//
//  StringTrimTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class StringTrimTests: XCTestCase {

    func testStrinTrimRemovedTrailingSpaces() {
        let original = "abc   "
        XCTAssertEqual(original.trim(), "abc")
    }

}
