//
//  ConstructorIOTrackAgentResultLoadStartedTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackAgentResultLoadStartedTests: XCTestCase {

    var constructor: ConstructorIO!
    let intent = "show me healthy snacks"
    let intentResultID = "179b8a0e-3799-4a31-be87-127b06871de2"

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackAgentResultLoadStarted() {
        let builder = CIOBuilder(expectation: "Calling trackAgentResultLoadStarted should send a valid request", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_result_load_start?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackAgentResultLoadStarted(intent: intent, intentResultID: intentResultID)
        self.wait(for: builder.expectation)
    }

    func testTrackAgentResultLoadStarted_WithSectionFromConfig() {
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackAgentResultLoadStarted should send a valid request with a section name from config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_result_load_start?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)
        constructor.trackAgentResultLoadStarted(intent: intent, intentResultID: intentResultID)
        self.wait(for: builder.expectation)
    }

    func testTrackAgentResultLoadStarted_With400() {
        let expectation = self.expectation(description: "Calling trackAgentResultLoadStarted with 400 should return badRequest CIOError.")
        let builder = CIOBuilder(expectation: "Calling trackAgentResultLoadStarted should send a valid request", builder: http(400))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_result_load_start?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackAgentResultLoadStarted(intent: intent, intentResultID: intentResultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackAgentResultLoadStarted_With500() {
        let expectation = self.expectation(description: "Calling trackAgentResultLoadStarted with 500 should return internalServerError CIOError.")
        let builder = CIOBuilder(expectation: "Calling trackAgentResultLoadStarted should send a valid request", builder: http(500))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_result_load_start?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackAgentResultLoadStarted(intent: intent, intentResultID: intentResultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackAgentResultLoadStarted_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackAgentResultLoadStarted with no connectivity should return noConnectivity CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_result_load_start?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackAgentResultLoadStarted(intent: intent, intentResultID: intentResultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
