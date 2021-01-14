//
//  ConstructorIOIntegrationTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

class ConstructorIOIntegrationTests: XCTestCase {

    fileprivate let testACKey = "key_K2hlXt5aVSwoI1Uw"
    fileprivate let searchTerm = "pork"
    fileprivate let session = 90
    fileprivate let filterName = "group_ids"
    fileprivate let filterValue = "544"
    fileprivate let resultCount = 123
    fileprivate let resultPositionOnPage = 3
    fileprivate let revenue = 7.99
    fileprivate let orderID = "234641"
    fileprivate let sectionName = "Products"
    fileprivate let itemName = "Boneless Pork Shoulder Roast"
    fileprivate let customerID = "prrst_shldr_bls"
    fileprivate let customerIDs = ["prrst_shldr_bls", "prrst_crwn"]
    fileprivate let originalQuery = "pork#@#??!!asd"
    fileprivate let group = CIOGroup(displayName: "groupName1", groupID: "groupID2", path: "path/to/group")

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: "key_K2hlXt5aVSwoI1Uw"))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTrackInputFocus() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackInputFocus(searchTerm: searchTerm, completionHandler: {  error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackAutocompleteSelect() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group, resultID: nil, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: originalQuery, group: group, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearchResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        let request = self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: sectionName, resultID: nil, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultsLoaded() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        var request = self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, resultID: nil, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, resultID: nil, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testConversion() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: sectionName, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testPurchase() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: sectionName, revenue: revenue, orderID: orderID, completionHandler: { error in
            let cioError = error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
