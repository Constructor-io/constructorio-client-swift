//
//  TestConstants.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import Foundation
import ConstructorAutocomplete

let kRegexTimestamp = "[1-9][0-9]*"
let kRegexClientID = "([A-Z0-9-])*"

struct TestConstants {
    static let defaultExpectationTimeout: TimeInterval = 1.0
    static let testApiKey = "key_OucJxxrfiTVUQx0C"
    static let testConfig = ConstructorIOConfig(apiKey: "key_OucJxxrfiTVUQx0C")

    static func testConstructor(_ config: ConstructorIOConfig = TestConstants.testConfig) -> ConstructorIO {
        let constructor = ConstructorIO(config: config)
        constructor.sessionManager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: Constants.Query.sessionIncrementTimeoutInSeconds, sessionLoader: NoSessionLoader())
        return constructor
    }
}
