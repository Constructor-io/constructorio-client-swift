//
//  ConstructorIOTrackQuizResultClick.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackQuizResultClick: XCTestCase {

    var constructor: ConstructorIO!

    // Required Parameters
    let quizID = "coffee quiz"
    let quizVersionID = "1231243"
    let quizSessionID = "13443"
    let customerID = "1123"

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

    func testTrackQuizResultClick() {
        let builder = CIOBuilder(expectation: "Calling trackQuizResultClick should send a valid request with the default section name.", builder: http(202))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackQuizResultClick(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackQuizResultClick_WithSection() {
        let builder = CIOBuilder(expectation: "Calling trackQuizResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=\(self.sectionName)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackQuizResultClick(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID, sectionName: self.sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackQuizResultClick_WithSectionFromConfig() {
        let builder = CIOBuilder(expectation: "Calling trackQuizResultClick should send a valid request with the custom default section name from the config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=testSection123&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "testSection123")
        let constructor = TestConstants.testConstructor(config)
        constructor.trackQuizResultClick(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID)
        self.wait(for: builder.expectation)
    }

    func testTrackQuizResultClick_With400() {
        let expectation = self.expectation(description: "Calling trackQuizResultClick with 400 should return badRequest CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackQuizResultClick(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackQuizResultClick_With500() {
        let expectation = self.expectation(description: "Calling trackQuizResultClick with 500 should return internalServerError CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackQuizResultClick(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackQuizResultClick_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackQuizResultClick with no connectvity should return noConnectivity CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/quiz_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackQuizResultClick(quizID: self.quizID, quizVersionID: self.quizVersionID, quizSessionID: self.quizSessionID, customerID: self.customerID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
