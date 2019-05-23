//
//  ConstructorIOTrackPurchaseTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import ConstructorAutocomplete

class ConstructorIOTrackPurchaseTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackPurchase() {
        let customerIDs = ["customer_id_q2ew"]
        let builder = CIOBuilder(expectation: "Calling trackPurchase should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_ids=customer_id_q2ew&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackPurchase_WithMultipleIDs() {
        let customerIDs = ["bumble", "bee", "autobot"]
        let builder = CIOBuilder(expectation: "Calling trackPurchase should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_ids=autobot&customer_ids=bee&customer_ids=bumble&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackPurchase_WithSection() {
        let customerIDs = ["customer_id_q2ew"]
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackPurchase should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&customer_ids=customer_id_q2ew&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackPurchase_WithOrderID() {
        let customerIDs = ["customer_id_q2ew"]
        let orderID = "ABCDEFGHI"
        let builder = CIOBuilder(expectation: "Calling trackPurchase should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_ids=customer_id_q2ew&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&order_id=ABCDEFGHI&s=\(kRegexSession)"), builder.create())
        self.constructor.trackPurchase(customerIDs: customerIDs, orderID: orderID)
        self.wait(for: builder.expectation)
    }

    func testTrackPurchase_With400() {
        let expectation = self.expectation(description: "Calling trackPurchase with 400 should return badRequest CIOError.")
        let customerIDs = ["customer_id_q2ew"]
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_ids=customer_id_q2ew&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(400))
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackPurchase_With500() {
        let expectation = self.expectation(description: "Calling trackPurchase with 500 should return internalServerError CIOError.")
        let customerIDs = ["customer_id_q2ew"]
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_ids=customer_id_q2ew&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(500))
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackPurchase_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackPurchase with no connectvity should return noConnectivity CIOError.")
        let customerIDs = ["customer_id_q2ew"]
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_ids=customer_id_q2ew&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
