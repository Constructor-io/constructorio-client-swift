//
//  Bundle+Test.swift
//  SearchFWTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import XCTest

extension Bundle {
    class func testBundle() -> Bundle {
        // pass any class from our test target
        return Bundle(for: ResultParserTests.self)
    }
}
