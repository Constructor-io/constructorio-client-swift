//
//  ConstructorIOTrackRecommendationResultClickTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackRecommendationResultClickTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackRecommendationResultClick() {
        let podID = "item_page_1"
        let customerID = "customerID123"

        let builder = CIOBuilder(expectation: "Calling trackRecommendationResultClick should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.trackRecommendationResultClick(podID: podID, customerID: customerID)
        self.wait(for: builder.expectation)
    }

    func testTrackRecommendationResultClick_WithOptionalParams() {
        let podID = "item_page_1"
        let strategyID = "alternative_items"
        let customerID = "customerID123"
        let variationID = "variationID456"
        let numResultsPerPage = 5
        let resultPage = 1
        let resultCount = 10
        let resultPositionOnPage = 2
        let sectionName = "Content"
        let resultID = "resultID789"

        let builder = CIOBuilder(expectation: "Calling trackRecommendationResultClick should send a valid request with optional params.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())

        self.constructor.trackRecommendationResultClick(podID: podID, strategyID: strategyID, customerID: customerID, variationID: variationID, numResultsPerPage: numResultsPerPage, resultPage: resultPage, resultCount: resultCount, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, resultID: resultID)
        self.wait(for: builder.expectation)
    }

    func testTrackRecommendationResultClick_WithSectionFromConfig() {
        let podID = "item_page_1"
        let customerID = "customerID123"
        let sectionName = "Content"

        let builder = CIOBuilder(expectation: "Calling trackRecommendationResultClick should send a valid request with the section from the client config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())

        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)

        constructor.trackRecommendationResultClick(podID: podID, customerID: customerID)
        self.wait(for: builder.expectation)
    }

    func testTrackRecommendationResultClick_With400() {
        let expectation = self.expectation(description: "Calling trackRecommendationResultClick with 400 should return badRequest CIOError.")
        let podID = "item_page_1"
        let customerID = "customerID123"

        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(400))

        self.constructor.trackRecommendationResultClick(podID: podID, customerID: customerID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackRecommendationResultClick_With500() {
        let expectation = self.expectation(description: "Calling trackRecommendationResultClick with 500 should return internalServerError CIOError.")
        let podID = "item_page_1"
        let customerID = "customerID123"

        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(500))

        self.constructor.trackRecommendationResultClick(podID: podID, customerID: customerID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackRecommendationResultClick_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackRecommendationResultClick with no connectivity should return noConnectivity CIOError.")
        let podID = "item_page_1"
        let customerID = "customerID123"

        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())

        self.constructor.trackRecommendationResultClick(podID: podID, customerID: customerID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
