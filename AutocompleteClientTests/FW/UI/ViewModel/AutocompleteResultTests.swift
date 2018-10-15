//
//  AutocompleteResultTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class AutocompleteResultTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testIsAfter_ifCorrectTimestampsArePassed() {
        let query = CIOAutocompleteQuery(query: "")
        let earlyResult = AutocompleteResult(query: query, timestamp: 10)
        let lateResult = AutocompleteResult(query: query, timestamp: 20)
        XCTAssertTrue(lateResult.isInitiatedAfter(result: earlyResult), "isAfter should return true if earlier initiated result is passed as a parameter")
    }

    func testIsAfter_ifIncorrectTimestampsArePassed() {
        let query = CIOAutocompleteQuery(query: "")
        let earlyResult = AutocompleteResult(query: query, timestamp: 20)
        let lateResult = AutocompleteResult(query: query, timestamp: 10)
        XCTAssertFalse(lateResult.isInitiatedAfter(result: earlyResult), "isAfter should return false if later initiated result is passed as a parameter")
    }

}
