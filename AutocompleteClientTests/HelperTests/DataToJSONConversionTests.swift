//
//  DataToJSONConversionTests.swift
//  AutocompleteClientTests
//
//  Created by Nikola Markovic on 1/4/19.
//  Copyright © 2019 xd. All rights reserved.
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
