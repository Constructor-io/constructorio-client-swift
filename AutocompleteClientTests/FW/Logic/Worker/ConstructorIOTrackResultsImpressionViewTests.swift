//
//  ConstructorIOTrackResultsImpressionViewTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackResultsImpressionViewTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackResultsImpressionView() {
        let builder = CIOBuilder(expectation: "Calling trackResultsImpressionView should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/impression_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        let items = [CIOResultItem(itemID: "item-1", itemName: "Item One")]
        self.constructor.trackResultsImpressionView(items: items, searchTerm: "shoes")
        self.wait(for: builder.expectation)
    }

    func testTrackResultsImpressionView_WithFilters() {
        let builder = CIOBuilder(expectation: "Calling trackResultsImpressionView with filters should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/impression_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        let items = [CIOResultItem(itemID: "item-1", itemName: "Item One")]
        self.constructor.trackResultsImpressionView(items: items, filterName: "category_id", filterValue: "shoes-123")
        self.wait(for: builder.expectation)
    }

    func testTrackResultsImpressionView_With400() {
        let expectation = self.expectation(description: "Calling trackResultsImpressionView with 400 should return badRequest CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/impression_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(400))
        let items = [CIOResultItem(itemID: "item-1", itemName: "Item One")]
        self.constructor.trackResultsImpressionView(items: items, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackResultsImpressionView_With500() {
        let expectation = self.expectation(description: "Calling trackResultsImpressionView with 500 should return internalServerError CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/impression_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), http(500))
        let items = [CIOResultItem(itemID: "item-1", itemName: "Item One")]
        self.constructor.trackResultsImpressionView(items: items, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackResultsImpressionView_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackResultsImpressionView with no connectivity should return noConnection CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/impression_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())
        let items = [CIOResultItem(itemID: "item-1", itemName: "Item One")]
        self.constructor.trackResultsImpressionView(items: items, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
