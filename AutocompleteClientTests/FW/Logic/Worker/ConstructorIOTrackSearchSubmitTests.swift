//
//  ConstructorIOTrackSearchSubmitTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackSearchSubmitTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackSearchSubmit() {
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_WithDefaultAnalyticsTagsOnly() {
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with only defaultAnalyticsTags should send the default tags.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&analytics_tags%5Bdefault_tag%5D=default_value&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_WithAnalyticsTagsOnly() {
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with only analyticsTags should send the passed tags.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&analytics_tags%5Btag1%5D=value1&analytics_tags%5Btag2%5D=value2&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, analyticsTags: ["tag1": "value1", "tag2": "value2"])
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_WithDefaultAndAnalyticsTagsMerged() {
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with both should merge defaultAnalyticsTags and analyticsTags.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&analytics_tags%5Bdefault_tag%5D=default_value&analytics_tags%5Btag1%5D=value1&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, analyticsTags: ["tag1": "value1"])
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_WithNoAnalyticsTags() {
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with no analytics tags should not send any.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_With400() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with 400 should return badRequest CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=\(searchTerm)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit_With500() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with 500 should return internalServerError CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
