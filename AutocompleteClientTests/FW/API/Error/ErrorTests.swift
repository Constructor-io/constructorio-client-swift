//
//  ErrorTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class ErrorTests: XCTestCase {

    func testUnknownErrorHasCorrectCode() {
        XCTAssertEqual(NSError.unknownError().code, kConstructorUnknownErrorCode)
    }

    func testParseErrorHasCorrectCode() {
        XCTAssertEqual(NSError.jsonParseError().code, kConstructorJSONErrorCode)
    }

    func testCIOErrorReturnsNonNilErrorDescription(){
        XCTAssertNotNil(CIOError.invalidResponse.errorDescription)
    }
}
