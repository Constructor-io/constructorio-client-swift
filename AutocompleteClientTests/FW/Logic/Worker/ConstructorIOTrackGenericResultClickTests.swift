//
//  ConstructorIOTrackGenericResultClickTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackGenericResultClickTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackGenericResultClick() {
        let itemName = "potato"
        let itemId = "itemID123"
        let variationId = "variationID123"
        let section = "Products"
        let builder = CIOBuilder(expectation: "Calling trackGenericResultClick should send a valid request", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackGenericResultClick(itemId: itemId, itemName: itemName, variationId: variationId, sectionName: section)
        self.wait(for: builder.expectation)
    }

    func testTrackGenericResultClick_With400() {
        let expectation = self.expectation(description: "Calling trackGenericResultClick with 400 should return badRequest CIOError.")
        let itemName = "potato"
        let itemId = "itemID123"
        let variationId = "variationID123"
        let section = "Products"
        let builder = CIOBuilder(expectation: "Calling trackGenericResultClick should send a valid request", builder: http(400))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackGenericResultClick(itemId: itemId, itemName: itemName, variationId: variationId, sectionName: section, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackGenericResultClick_With500() {
        let expectation = self.expectation(description: "Calling trackGenericResultClick with 500 should return internalServerError CIOError.")
        let itemName = "potato"
        let itemId = "itemID123"
        let variationId = "variationID123"
        let section = "Products"
        let builder = CIOBuilder(expectation: "Calling trackGenericResultClick should send a valid request", builder: http(500))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackGenericResultClick(itemId: itemId, itemName: itemName, variationId: variationId, sectionName: section, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackGenericResultClick_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackGenericResultClick with no connectivity should return noConnectivity CIOError.")
        let itemName = "potato"
        let itemId = "itemID123"
        let variationId = "variationID123"
        let section = "Products"
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackGenericResultClick(itemId: itemId, itemName: itemName, variationId: variationId, sectionName: section, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
