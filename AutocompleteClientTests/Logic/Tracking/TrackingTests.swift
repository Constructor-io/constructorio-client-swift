//
//  TrackingTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import OHHTTPStubs
import Foundation
@testable import ConstructorAutocomplete

class TrackingTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: TestConstants.testConfig)
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testTracking_Conversion(){
        let searchTerm = "corn"
        let itemID = "green-giant-corn-can-12oz"
        let revenue = 1
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/conversion?i=\(kRegexClientID)&item_id=green-giant-corn-can-12oz&revenue=1&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&_dt=\(kRegexTimestamp)"), builder.create())
        
        self.constructor.tracking.trackConversion(itemID: itemID, revenue: revenue, searchTerm: searchTerm)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_AutocompleteSelect(){
        let searchTerm = "corn"
        let searchOriginalQuery = "co"
        let builder = CIOBuilder(expectation: "Calling trackAutocomplete should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/select?tr=click&i=\(kRegexClientID)&c=cioios-&original_query=co&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&_dt=\(kRegexTimestamp)"), builder.create())
        self.constructor.tracking.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchSubmit(){
        let searchTerm = "corn"
        let searchOriginalQuery = "corn"
        let builder = CIOBuilder(expectation: "Calling trackSearch should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/corn/search?c=cioios-&s=1&_dt=\(kRegexTimestamp)&i=\(kRegexClientID)&original_query=corn&autocomplete_key=key_OucJxxrfiTVUQx0C"), builder.create())
        self.constructor.tracking.trackSearchSubmit(searchTerm: searchTerm, originalQuery: searchOriginalQuery)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultsLoaded(){
        let searchTermValue = "term_search"
        let resultCount = 12
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))

        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&i=\(kRegexClientID)&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&term=term_search&num_results=12"), builder.create())
        self.constructor.tracking.trackSearchResultsLoaded(searchTerm: searchTermValue, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }
}
