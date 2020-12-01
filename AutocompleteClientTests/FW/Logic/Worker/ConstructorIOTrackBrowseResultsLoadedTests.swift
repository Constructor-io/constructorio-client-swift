//
//  ConstructorIOTrackBrowseResultsLoadedTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import ConstructorAutocomplete

class ConstructorIOTrackBrowseResultsLoadedTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackBrowseResultsLoaded() {
        let filterName = "potato"
        let filterValue = "russet"
        let resultCount = 12
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), builder.create())
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultsLoaded_With400() {
        let expectation = self.expectation(description: "Calling trackBrowseResultsLoaded with 400 should return badRequest CIOError.")
        let filterName = "potato"
        let filterValue = "russet"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), http(400))
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackBrowseResultsLoaded_With500() {
        let expectation = self.expectation(description: "Calling trackBrowseResultsLoaded with 500 should return internalServerError CIOError.")
        let filterName = "potato"
        let filterValue = "russet"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), http(500))
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackBrowseResultsLoaded_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackBrowseResultsLoaded with no connectvity should return noConnectivity CIOError.")
        let filterName = "potato"
        let filterValue = "russet"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), noConnectivity())
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
