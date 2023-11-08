//
//  ConstructorIOTrackBrowseResultsLoadedTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackBrowseResultsLoadedTests: XCTestCase {

    fileprivate let filterName = "potato"
    fileprivate let filterValue = "russet"
    fileprivate let resultCount = 12
    fileprivate let resultID = "result-id"
    fileprivate let customerIDs = ["10001", "10002"]

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
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), builder.create())
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, customerIDs: customerIDs, resultID: resultID)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultsLoaded_With400() {
        let expectation = self.expectation(description: "Calling trackBrowseResultsLoaded with 400 should return badRequest CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(400))
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, customerIDs: customerIDs, resultID: resultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackBrowseResultsLoaded_With500() {
        let expectation = self.expectation(description: "Calling trackBrowseResultsLoaded with 500 should return internalServerError CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), http(500))
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, customerIDs: customerIDs, resultID: resultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackBrowseResultsLoaded_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackBrowseResultsLoaded with no connectvity should return noConnectivity CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/browse_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, customerIDs: customerIDs, resultID: resultID, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
