//
//  ConstructorIOTrackingTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import Foundation
import ConstructorAutocomplete

class ConstructorIOTrackingTests: XCTestCase {

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackInputFocus() {
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn"), builder.create())
        self.constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }

    func testTrackInputFocus_With400() {
        let expectation = self.expectation(description: "Calling trackInputFocus with 400 should return badRequest CIOError.")
        let searchTerm = "corn"
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn"), http(400))
        self.constructor.trackInputFocus(searchTerm: searchTerm, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackInputFocus_With500() {
        let expectation = self.expectation(description: "Calling trackInputFocus with 500 should return internalServerError CIOError.")
        let searchTerm = "corn"
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn"), http(500))
        self.constructor.trackInputFocus(searchTerm: searchTerm, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackInputFocus_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackInputFocus with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "corn"
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=focus&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&term=corn"), noConnectivity())
        self.constructor.trackInputFocus(searchTerm: searchTerm, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackAutocompleteSelect() {
        let searchTerm = "corn"
        let searchOriginalQuery = "co"
        let searchSectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackAutocompleteSelect should send a valid request.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=co&s=\(kRegexSession)&tr=click"), builder.create())
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: searchOriginalQuery, sectionName: searchSectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackAutocompleteSelect_With400() {
        let expectation = self.expectation(description: "Calling trackAutocompleteSelect with 400 should return badRequest CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "co"
        let searchSectionName = "Search Suggestions"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=co&s=\(kRegexSession)&tr=click"), http(400))
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: searchOriginalQuery, sectionName: searchSectionName, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackAutocompleteSelect_With500() {
        let expectation = self.expectation(description: "Calling trackAutocompleteSelect with 500 should return internalServerError CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "co"
        let searchSectionName = "Search Suggestions"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=co&s=\(kRegexSession)&tr=click"), http(500))
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: searchOriginalQuery, sectionName: searchSectionName, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackAutocompleteSelect_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackAutocompleteSelect with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "co"
        let searchSectionName = "Search Suggestions"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=co&s=\(kRegexSession)&tr=click"), noConnectivity())
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: searchOriginalQuery, sectionName: searchSectionName, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit() {
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)"), builder.create())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_With400() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with 400 should return badRequest CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=\(searchTerm)&s=\(kRegexSession)"), http(400))
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit_With500() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with 500 should return internalServerError CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)"), http(500))
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&original_query=corn&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded() {
        let searchTerm = "term_search"
        let resultCount = 12
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), builder.create())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoaded_With400() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with 400 should return badRequest CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), http(400))
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded_With500() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with 500 should return internalServerError CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), http(500))
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&num_results=12&s=\(kRegexSession)&term=term_search"), noConnectivity())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultClick() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_NoTerm() {
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_WithSection() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultClick_WithSectionFromConfig() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=section321&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), builder.create())
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
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), http(400))
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
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
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), http(500))
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
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
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackConversion() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_NoTerm() {
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/conversion?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_WithSection() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?_dt=\(kRegexTimestamp)&autocomplete_section=Search%20Suggestions&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_WithSectionFromConfig() {
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "section321"
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?_dt=\(kRegexTimestamp)&autocomplete_section=\(sectionName)&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        let constructor = TestConstants.testConstructor(config)
        constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }

    func testTrackConversion_With400() {
        let expectation = self.expectation(description: "Calling trackConversion with 400 should return badRequest CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)"), http(400))
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackConversion_With500() {
        let expectation = self.expectation(description: "Calling trackConversion with 500 should return internalServerError CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)"), http(500))
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackConversion_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackConversion with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?_dt=\(kRegexTimestamp)&autocomplete_section=Products&c=\(kRegexVersion)&customer_id=customerID123&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&name=green-giant-corn-can-12oz&revenue=1.00&s=\(kRegexSession)"), noConnectivity())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil, completionHandler: { error in
            if let cioError = error as? CIOError {
                XCTAssertEqual(cioError, CIOError.noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
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
