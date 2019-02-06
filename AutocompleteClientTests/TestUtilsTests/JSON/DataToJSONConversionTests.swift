//
//  DataToJSONConversionTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest

class DataToJSONConversionTests: XCTestCase {

    func testInvalidDataReturnsNilJSONDictionary(){
        XCTAssertNil("123456".data(using: String.Encoding.utf8)?.toJSONDictionary())
    }

    func testValidDataReturnsNonNilJSONDictionary(){
        XCTAssertNotNil("{\"key\": \"value\"}".data(using: String.Encoding.utf8)?.toJSONDictionary())
    }

}
