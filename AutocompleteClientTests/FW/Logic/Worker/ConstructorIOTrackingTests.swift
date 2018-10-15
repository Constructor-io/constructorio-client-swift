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
@testable import ConstructorAutocomplete

class ConstructorIOTrackingTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testTrackInputFocus(){
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?term=corn&i=\(kRegexClientID)&_dt=\(kRegexTimestamp)&key=key_OucJxxrfiTVUQx0C&action=focus&c=cioios-&s=1"), builder.create())
        self.constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }
    
    func testTrackAutocompleteSelect(){
        let searchTerm = "corn"
        let searchOriginalQuery = "co"
        let searchSectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackAutocompleteSelect should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?_dt=\(kRegexTimestamp)&s=1&original_query=co&tr=click&c=cioios-&key=key_OucJxxrfiTVUQx0C&i=\(kRegexClientID)&autocomplete_section=Search%20Suggestions"), builder.create())
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: searchOriginalQuery, sectionName: searchSectionName)
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchSubmit(){
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?key=key_OucJxxrfiTVUQx0C&c=cioios-&original_query=corn&_dt=\(kRegexTimestamp)&s=1&i=\(kRegexClientID)"), builder.create())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchResultsLoaded(){
        let searchTermValue = "term_search"
        let resultCount = 12
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?i=\(kRegexClientID)&_dt=\(kRegexTimestamp)&c=cioios-&s=1&action=search-results&key=key_OucJxxrfiTVUQx0C&term=term_search&num_results=12"), builder.create())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTermValue, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchResultClick(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?s=1&c=cioios-&_dt=\(kRegexTimestamp)&customer_id=customerID123&autocomplete_section=Products&key=key_OucJxxrfiTVUQx0C&name=green-giant-corn-can-12oz&i=\(kRegexClientID)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchResultClick_NoTerm(){
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/click_through?c=cioios-&autocomplete_section=Products&s=1&name=green-giant-corn-can-12oz&key=key_OucJxxrfiTVUQx0C&customer_id=customerID123&i=\(kRegexClientID)&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchResultClick_WithSection(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&autocomplete_section=Search%20Suggestions&c=cioios-&customer_id=customerID123&name=green-giant-corn-can-12oz&_dt=\(kRegexTimestamp)&s=1"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchResultClick_withSectionFromConfig(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "section321"
        
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?key=key_OucJxxrfiTVUQx0C&s=1&name=green-giant-corn-can-12oz&c=cioios-&i=\(kRegexClientID)&_dt=\(kRegexTimestamp)&autocomplete_section=section321&customer_id=customerID123"), builder.create())
        
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        
        let constructor = ConstructorIO(config: config)
        constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil)
        
        self.wait(for: builder.expectation)
    }
    
    func testTrackConversion(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?revenue=1.00&_dt=\(kRegexTimestamp)&c=cioios-&i=\(kRegexClientID)&customer_id=customerID123&autocomplete_section=Products&name=green-giant-corn-can-12oz&s=1&key=key_OucJxxrfiTVUQx0C"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTrackConversion_NoTerm(){
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/conversion?i=\(kRegexClientID)&autocomplete_section=Products&key=key_OucJxxrfiTVUQx0C&c=cioios-&name=green-giant-corn-can-12oz&_dt=\(kRegexTimestamp)&revenue=1.00&customer_id=customerID123&s=1"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTrackConversion_withSection(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?autocomplete_section=Search%20Suggestions&_dt=\(kRegexTimestamp)&s=1&name=green-giant-corn-can-12oz&c=cioios-&revenue=1.00&customer_id=customerID123&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }
    
    func testTrackConversion_withSectionFromConfig(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "section321"
        
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?_dt=\(kRegexTimestamp)&key=key_OucJxxrfiTVUQx0C&name=green-giant-corn-can-12oz&customer_id=customerID123&autocomplete_section=section321&s=1&c=cioios-&revenue=1.00&i=\(kRegexClientID)"), builder.create())
        
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: sectionName)
        
        let constructor = ConstructorIO(config: config)
        constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }
}
