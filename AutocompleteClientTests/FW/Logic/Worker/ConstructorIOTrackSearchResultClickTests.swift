//
//  ConstructorIOTrackSearchResultClickTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackSearchResultClickTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackSearchResultClick() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_NoTerm() {
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_EmptyTerm() {
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: "", sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_WithVariationID() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let variationID = "variationID456"
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Search%20Suggestions&\(TestConstants.defaultSegments)&variation_id=variationID456"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, variationID: variationID, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_WithSection() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Search%20Suggestions&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_WithResultID() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let resultID = "0123456789"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&result_id=0123456789&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil, resultID: resultID)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_WithSectionFromConfig() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=section321&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)
        constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_With400() {
        let expectation = self.expectation(description: "Calling trackSearchResultClick with 400 should return badRequest CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultClick_With500() {
        let expectation = self.expectation(description: "Calling trackSearchResultClick with 500 should return internalServerError CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultClick_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackSearchResultClick with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
