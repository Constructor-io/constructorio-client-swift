//
//  TestConstants.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
@testable import ConstructorAutocomplete

let kRegexTimestamp = "[1-9][0-9]*"
let kRegexClientID = "([A-Z0-9-])*"

struct TestConstants {
    static let defaultExpectationTimeout: TimeInterval = 10.0
    static let testapiKey = "key_OucJxxrfiTVUQx0C"
    static let testConfig = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C")
}
