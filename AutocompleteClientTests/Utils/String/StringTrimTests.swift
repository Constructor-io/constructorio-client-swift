//
//  StringTrimTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
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
