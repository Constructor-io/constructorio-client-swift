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
        var capturedRequest: URLRequest?
        let builder = CIOBuilder(expectation: "Calling trackResultsImpressionView should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/impression_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        let items = [CIOResultItem(itemID: "item-1", itemName: "Item One")]
        self.constructor.trackResultsImpressionView(items: items, searchTerm: "shoes", completionHandler: { response in
            XCTAssertNil(response.error, "Happy-path tracking call should not return an error")
        })
        self.wait(for: builder.expectation)

        let body = capturedRequest?.ohhttpStubs_httpBody
        let payload = body.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
        XCTAssertEqual(payload?["search_term"] as? String, "shoes")
        let itemsArray = payload?["items"] as? [[String: Any]] ?? []
        XCTAssertEqual(itemsArray.count, 1)
        XCTAssertEqual(itemsArray[0]["item_id"] as? String, "item-1")
        XCTAssertEqual(itemsArray[0]["item_name"] as? String, "Item One")
    }

    func testTrackResultsImpressionView_WithFilters() {
        var capturedRequest: URLRequest?
        let builder = CIOBuilder(expectation: "Calling trackResultsImpressionView with filters should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/impression_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        let items = [CIOResultItem(itemID: "item-1", itemName: "Item One")]
        self.constructor.trackResultsImpressionView(items: items, filterName: "category_id", filterValue: "shoes-123", completionHandler: { response in
            XCTAssertNil(response.error, "Happy-path tracking call should not return an error")
        })
        self.wait(for: builder.expectation)

        let body = capturedRequest?.ohhttpStubs_httpBody
        let payload = body.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["filter_name"] as? String, "category_id")
        XCTAssertEqual(payload?["filter_value"] as? String, "shoes-123")
        XCTAssertNil(payload?["search_term"], "search_term should not be present when not provided")
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
