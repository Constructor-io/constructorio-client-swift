//
//  ErrorTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class ErrorTests: XCTestCase {

    func testUnknownErrorHasCorrectCode() {
        XCTAssertEqual(NSError.unknownError().code, kConstructorUnknownErrorCode)
    }

    func testParseErrorHasCorrectCode() {
        XCTAssertEqual(NSError.jsonParseError().code, kConstructorJSONErrorCode)
    }

    func testCIOErrorReturnsNonNilErrorDescription() {
        XCTAssertNotNil(CIOError(errorType: .invalidResponse).errorDescription)
    }

    func testCIOErrorWithReturnsNonNilErrorMessage() {
        XCTAssertNotNil(CIOError(errorType: .badRequest, errorMessage: "Invalid parameter supplied with the request.").errorMessage)
    }
}
