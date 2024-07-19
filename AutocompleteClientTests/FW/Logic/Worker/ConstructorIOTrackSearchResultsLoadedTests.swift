//
//  ConstructorIOTrackSearchResultsLoadedTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackSearchResultsLoadedTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackSearchResultsLoaded() {
        let searchTerm = "term_search"
        let resultCount = 12
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoadedWithCustomerIDs() {
        let searchTerm = "term_search"
        let resultCount = 12
        let customerIDs = ["abc", "123"]
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&customer_ids=abc,123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, customerIDs: customerIDs)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoaded_With400() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with 400 should return badRequest CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded_With500() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with 500 should return internalServerError CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
