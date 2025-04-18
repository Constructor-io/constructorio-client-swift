//
//  ConstructorIOTrackQuizResultsLoadedTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackQuizResultsLoadedTests: XCTestCase {

    var constructor: ConstructorIO!

    // Required Parameters
    let quizID = "coffee quiz"
    let quizVersionID = "1231243"
    let quizSessionID = "13443"
    let url = "www.example.com"

    // Optional Parameters
    let sectionName = "Products"

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackQuizResultsLoaded() {
        let builder = CIOBuilder(expectation: "Calling trackQuizResultsLoaded should send a valid request with the default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackQuizResultsLoaded(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID)
        self.wait(for: builder.expectation)
    }

    func testTrackQuizResultsLoaded_WithSection() {
        let builder = CIOBuilder(expectation: "Calling trackQuizResultsLoaded should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=\(self.sectionName)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackQuizResultsLoaded(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, sectionName: self.sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackQuizResultsLoaded_WithSectionFromConfig() {
        let builder = CIOBuilder(expectation: "Calling trackQuizResultsLoaded should send a valid request with the custom default section name from the config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=testSection123&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "testSection123")
        let constructor = TestConstants.testConstructor(config)
        constructor.trackQuizResultsLoaded(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID)
        self.wait(for: builder.expectation)
    }

    func testTrackQuizResultsLoaded_With400() {
        let expectation = self.expectation(description: "Calling trackQuizResultsLoaded with 400 should return badRequest CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackQuizResultsLoaded(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackQuizResultsLoaded_With500() {
        let expectation = self.expectation(description: "Calling trackQuizResultsLoaded with 500 should return internalServerError CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackQuizResultsLoaded(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackQuizResultsLoaded_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackQuizResultsLoaded with no connectvity should return noConnectivity CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackQuizResultsLoaded(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
