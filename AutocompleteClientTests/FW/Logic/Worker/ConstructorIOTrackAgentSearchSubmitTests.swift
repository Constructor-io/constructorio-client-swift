//
//  ConstructorIOTrackAgentSearchSubmitTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackAgentSearchSubmitTests: XCTestCase {

    var constructor: ConstructorIO!
    let intent = "show me healthy snacks"
    let searchTerm = "trail mix"
    let searchResultID = "179b8a0e-3799-4a31-be87-127b06871de2"

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackAgentSearchSubmit() {
        let builder = CIOBuilder(expectation: "Calling trackAgentSearchSubmit should send a valid request", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_submit?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackAgentSearchSubmit(intent: intent, searchTerm: searchTerm, searchResultID: searchResultID)
        self.wait(for: builder.expectation)
    }

    func testTrackAgentSearchSubmit_WithSectionFromConfig() {
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackAgentSearchSubmit should send a valid request with a section name from config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_submit?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)
        constructor.trackAgentSearchSubmit(intent: intent, searchTerm: searchTerm, searchResultID: searchResultID)
        self.wait(for: builder.expectation)
    }

    func testTrackAgentSearchSubmit_With400() {
        let expectation = self.expectation(description: "Calling trackAgentSearchSubmit with 400 should return badRequest CIOError.")
        let builder = CIOBuilder(expectation: "Calling trackAgentSearchSubmit should send a valid request", builder: http(400))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_submit?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackAgentSearchSubmit(intent: intent, searchTerm: searchTerm, searchResultID: searchResultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackAgentSearchSubmit_With500() {
        let expectation = self.expectation(description: "Calling trackAgentSearchSubmit with 500 should return internalServerError CIOError.")
        let builder = CIOBuilder(expectation: "Calling trackAgentSearchSubmit should send a valid request", builder: http(500))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_submit?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackAgentSearchSubmit(intent: intent, searchTerm: searchTerm, searchResultID: searchResultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackAgentSearchSubmit_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackAgentSearchSubmit with no connectivity should return noConnectivity CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_submit?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackAgentSearchSubmit(intent: intent, searchTerm: searchTerm, searchResultID: searchResultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
