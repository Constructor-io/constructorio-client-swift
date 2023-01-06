//
//  ConstructorIOTrackItemDetailLoadTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import ConstructorAutocomplete

class ConstructorIOTrackItemDetailLoadTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackItemDetailLoad() {
        let itemName = "potato"
        let customerID = "customerID123"
        let variationID = "variationID123"
        let section = "Merchants"
        let builder = CIOBuilder(expectation: "Calling trackItemDetailLoad should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/item_detail_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackItemDetailLoad(customerID: customerID, itemName: itemName, variationID: variationID, sectionName: section)
        self.wait(for: builder.expectation)
    }

    func testTrackItemDetailLoad_With400() {
        let expectation = self.expectation(description: "Calling trackItemDetailLoad with 400 should return badRequest CIOError.")
        let itemName = "potato"
        let customerID = "customerID123"
        let variationID = "variationID123"
        let section = "Merchants"
        let builder = CIOBuilder(expectation: "Calling trackItemDetailLoad should send a valid request with a default section name.", builder: http(400))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/item_detail_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackItemDetailLoad(customerID: customerID, itemName: itemName, variationID: variationID, sectionName: section, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackItemDetailLoad_With500() {
        let expectation = self.expectation(description: "Calling trackItemDetailLoad with 500 should return badRequest CIOError.")
        let itemName = "potato"
        let customerID = "customerID123"
        let variationID = "variationID123"
        let section = "Merchants"
        let builder = CIOBuilder(expectation: "Calling trackItemDetailLoad should send a valid request with a default section name.", builder: http(500))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/item_detail_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackItemDetailLoad(customerID: customerID, itemName: itemName, variationID: variationID, sectionName: section, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackItemDetailLoad_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackItemDetailLoad with no connectvity should return noConnectivity CIOError.")
        let itemName = "potato"
        let customerID = "customerID123"
        let variationID = "variationID123"
        let section = "Merchants"
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/item_detail_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackItemDetailLoad(customerID: customerID, itemName: itemName, variationID: variationID, sectionName: section, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
