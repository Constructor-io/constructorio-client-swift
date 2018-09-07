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

struct TestConstants {
    static let defaultExpectationTimeout: TimeInterval = 10.0
    static let testAutocompleteKey = "key_OucJxxrfiTVUQx0C"
    static let testConfig = AutocompleteConfig(autocompleteKey: "key_OucJxxrfiTVUQx0C")
}
