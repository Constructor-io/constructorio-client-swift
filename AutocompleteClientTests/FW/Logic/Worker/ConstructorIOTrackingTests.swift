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
    
    func testTracking_InputFocus(){
        let searchTerm = "corn"
        let builder = CIOBuilder(expectation: "Calling trackInputFocus should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?action=focus&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&term=corn&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackInputFocus(searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_AutocompleteSelect(){
        let searchTerm = "corn"
        let searchOriginalQuery = "co"
        let searchSectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackAutocompleteSelect should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?tr=click&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&original_query=co&c=cioios-&s=1&autocomplete_section=Search%20Suggestions&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: searchOriginalQuery, sectionName: searchSectionName)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchSubmit(){
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?_dt=\(kRegexTimestamp)&s=1&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&original_query=corn&c=cioios-"), builder.create())
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultsLoaded(){
        let searchTermValue = "term_search"
        let resultCount = 12
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&term=term_search&num_results=12"), builder.create())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTermValue, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultClick(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=Products&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultClick_NoTerm(){
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/click_through?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=Products&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultClick_WithSection(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackSearchResultClick should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=Search%20Suggestions&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_Conversion(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&revenue=1.00&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=Products&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_Conversion_NoTerm(){
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a default section name and default term.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/conversion?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&revenue=1.00&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=Products&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: nil, sectionName: nil)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_Conversion_withSection(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "Search Suggestions"
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&revenue=1.00&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=Search%20Suggestions&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: sectionName)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_Conversion_FallsBackToConfigForSection_IfParameterIsNil(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let revenue: Double = 1
        let sectionName = "section321"
        
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&revenue=1.00&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=\(sectionName)&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())
        
        let config = ConstructorIOConfig(apiKey: TestConstants.testAutocompleteKey, defaultSectionName: sectionName)
        
        let constructor = ConstructorIO(config: config)
        constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_AutocompleteSelect_FallsBackToConfigForSection_IfParameterIsNil(){
        let searchTerm = "corn"
        let originalQuery = "green-giant-corn-can-12oz"
        let sectionName = "section321"
        
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?tr=click&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&original_query=green-giant-corn-can-12oz&c=cioios-&s=1&autocomplete_section=section321&_dt=\(kRegexTimestamp)"), builder.create())
        
        let config = ConstructorIOConfig(apiKey: TestConstants.testAutocompleteKey, defaultSectionName: sectionName)
        
        let constructor = ConstructorIO(config: config)
        constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: originalQuery)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultClick_FallsBackToConfigForSection_IfParameterIsNil(){
        let searchTerm = "corn"
        let itemName = "green-giant-corn-can-12oz"
        let customerID = "customerID123"
        let sectionName = "section321"

        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request with a section name.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/click_through?name=green-giant-corn-can-12oz&i=\(kRegexClientID)&key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&autocomplete_section=section321&customer_id=customerID123&_dt=\(kRegexTimestamp)"), builder.create())

        let config = ConstructorIOConfig(apiKey: TestConstants.testAutocompleteKey, defaultSectionName: sectionName)

        let constructor = ConstructorIO(config: config)
        constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: nil)
        
        self.wait(for: builder.expectation)
    }
}
