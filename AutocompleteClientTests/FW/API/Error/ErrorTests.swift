//
//  ErrorTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class ErrorTests: XCTestCase {

    func testUnknownErrorHasCorrectCode() {
        XCTAssertEqual(NSError.unknownError().code, kConstructorUnknownErrorCode)
    }

    func testParseErrorHasCorrectCode() {
        XCTAssertEqual(NSError.jsonParseError().code, kConstructorJSONErrorCode)
    }

    func testCIOErrorReturnsNonNilErrorDescription() {
        print(CIOError.invalidResponse)
        XCTAssertNotNil(CIOError.invalidResponse.errorDescription)
    }
}
