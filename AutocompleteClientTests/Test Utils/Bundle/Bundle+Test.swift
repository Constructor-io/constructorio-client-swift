//
//  Bundle+Test.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import XCTest

extension Bundle {
    class func testBundle() -> Bundle {
        // pass any class from our test target
        return Bundle(for: CIOAutocompleteResponseParserTests.self)
    }
}
