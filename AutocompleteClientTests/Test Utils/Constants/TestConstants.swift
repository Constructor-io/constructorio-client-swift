//
//  TestConstants.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

let kRegexTimestamp = "[1-9][0-9]*"
let kRegexClientID = "([A-Z0-9-])*"
let kRegexSession = "[0-9]*"
let kRegexAutocompleteKey = "[a-zA-Z-_0-9]*"
let kRegexVersion = "cioios-[\\d\\.]*"

struct TestConstants {
    static let defaultUserInterfaceExpectationTimeout: TimeInterval = 50.0
    static let defaultExpectationTimeout: TimeInterval = 1.5
    static let testApiKey = "key_OucJxxrfiTVUQx0C"
    static let testConfig = ConstructorIOConfig(apiKey: testApiKey)
    static let defaultSegments = "us=cio-app&us=cio-ios"

    static func testConstructor(_ config: ConstructorIOConfig = TestConstants.testConfig) -> ConstructorIO {
        let constructor = ConstructorIO(config: config)
        constructor.sessionManager = CIOSessionManager(dateProvider: CurrentTimeDateProvider(), timeout: Constants.Query.sessionIncrementTimeoutInSeconds, sessionLoader: NoSessionLoader())
        return constructor
    }
}
