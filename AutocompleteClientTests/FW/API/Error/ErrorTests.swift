//
//  ErrorTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
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
