//
//  ConstructorIOTrackBrowseResultClickTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import ConstructorAutocomplete

class ConstructorIOTrackBrowseResultClickTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackBrowseResultClick() {
        let filterName = "potato"
        let filterValue = "russet"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_WithSection() {
        let filterName = "potato"
        let filterValue = "russet"
        let customerID = "customerID123"
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: nil, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_WithResultID() {
        let filterName = "potato"
        let filterValue = "russet"
        let customerID = "customerID123"
        let resultID = "0123456789"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: nil,    sectionName: nil, resultID: resultID)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_WithSectionFromConfig() {
        let filterName = "potato"
        let filterValue = "russet"
        let customerID = "customerID123"
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)
        constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_With400() {
        let expectation = self.expectation(description: "Calling trackBrowseResultClick with 400 should return badRequest CIOError.")
        let filterName = "potato"
        let filterValue = "russet"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(400))
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: nil, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackBrowseResultClick_With500() {
        let expectation = self.expectation(description: "Calling trackBrowseResultClick with 500 should return internalServerError CIOError.")
        let filterName = "potato"
        let filterValue = "russet"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(500))
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: nil, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackBrowseResultClick_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackBrowseResultClick with no connectvity should return noConnectivity CIOError.")
        let filterName = "potato"
        let filterValue = "russet"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: nil, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
