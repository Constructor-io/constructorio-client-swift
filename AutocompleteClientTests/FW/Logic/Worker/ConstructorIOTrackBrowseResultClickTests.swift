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
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a default section name.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), builder.create())
        self.constructor.trackBrowseResultClick(itemName: itemName, customerID: customerID, filterName: filterName, filterValue: filterValue, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_WithSection() {
        let filterName = "potato"
        let filterValue = "russet"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), builder.create())
        self.constructor.trackBrowseResultClick(itemName: itemName, customerID: customerID, filterName: filterName, filterValue: filterValue, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_WithResultID() {
        let filterName = "potato"
        let filterValue = "russet"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let resultID = "0123456789"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&result_id=0123456789&s=\(kRegexSession)"), builder.create())
        self.constructor.trackBrowseResultClick(itemName: itemName, customerID: customerID, filterName: filterName, filterValue: filterValue, sectionName: nil, resultID: resultID)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_WithSectionFromConfig() {
        let filterName = "potato"
        let filterValue = "russet"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackBrowseResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=section321&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)
        constructor.trackBrowseResultClick(itemName: itemName, customerID: customerID, filterName: filterName, filterValue: filterValue, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackBrowseResultClick_With400() {
        let expectation = self.expectation(description: "Calling trackBrowseResultClick with 400 should return badRequest CIOError.")
        let filterName = "potato"
        let filterValue = "russet"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), http(400))
        self.constructor.trackBrowseResultClick(itemName: itemName, customerID: customerID, filterName: filterName, filterValue: filterValue, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
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
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), http(500))
        self.constructor.trackBrowseResultClick(itemName: itemName, customerID: customerID, filterName: filterName, filterValue: filterValue, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
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
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackBrowseResultClick(itemName: itemName, customerID: customerID, filterName: filterName, filterValue: filterValue, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
