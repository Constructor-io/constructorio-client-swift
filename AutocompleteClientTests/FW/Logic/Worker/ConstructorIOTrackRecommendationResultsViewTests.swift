//
//  ConstructorIOTrackRecommendationResultsViewTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import ConstructorAutocomplete

class ConstructorIOTrackRecommendationResultsViewTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackRecommendationResultsView() {
        let podID = "item_page_1"

        let builder = CIOBuilder(expectation: "Calling trackRecommendationResultsView should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.trackRecommendationResultsView(podID: podID)
        self.wait(for: builder.expectation)
    }

    func testTrackRecommendationResultsView_WithOptionalParams() {
        let podID = "item_page_1"
        let numResultsViewed = 5
        let resultPage = 1
        let resultCount = 10
        let sectionName = "Content"
        let resultID = "resultID789"

        let builder = CIOBuilder(expectation: "Calling trackRecommendationResultsView should send a valid request with optional params.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        self.constructor.trackRecommendationResultsView(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID)
        self.wait(for: builder.expectation)
    }

    func testTrackRecommendationResultsView_WithSectionFromConfig() {
        let podID = "item_page_1"
        let sectionName = "Content"

        let builder = CIOBuilder(expectation: "Calling trackRecommendationResultsView should send a valid request with the section from the client config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())

        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)

        constructor.trackRecommendationResultsView(podID: podID)
        self.wait(for: builder.expectation)
    }

    func testTrackRecommendationResultsView_With400() {
        let expectation = self.expectation(description: "Calling trackRecommendationResultsView with 400 should return badRequest CIOError.")
        let podID = "item_page_1"

        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(400))

        self.constructor.trackRecommendationResultsView(podID: podID, completionHandler: { response in
                if let cioError = response.error as? CIOError {
                    XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                    expectation.fulfill()
                }
            }
        )
        self.wait(for: expectation)
    }

    func testTrackRecommendationResultsView_With500() {
        let expectation = self.expectation(description: "Calling trackRecommendationResultsView with 500 should return internalServerError CIOError.")
        let podID = "item_page_1"

        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(500))

        self.constructor.trackRecommendationResultsView(podID: podID, completionHandler: {
            response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackRecommendationResultsView_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackRecommendationResultsView with no connectivity should return noConnectivity CIOError.")
        let podID = "item_page_1"

        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/recommendation_result_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), noConnectivity())

        self.constructor.trackRecommendationResultsView(podID: podID, completionHandler: {
            response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
