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
        self.constructor = ConstructorIO(autocompleteKey: TestConstants.testAutocompleteKey, clientID: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testTracking_Conversion(){
        let itemIDValue = "item_ID"
        let revenueValue = 1
        let searchTermValue = "term_search"
        
        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/term_search/conversion?c=cioios-&_dt=\(kRegexTimestamp)&item_id=item_ID&autocomplete_section=Products&revenue=1&autocomplete_key=key_OucJxxrfiTVUQx0C"), builder.create())
        
        self.constructor.tracking.trackConversion(itemID: itemIDValue, revenue: revenueValue, searchTerm: searchTermValue)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_AutocompleteClick(){
        let itemNameValue = "item_name"
        let searchTermValue = "term_search"
   
        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackAutocomplete should send a valid request.", builder: http(200))
        
        stub(regex("https://ac.cnstrc.com/autocomplete/item_name/select?c=cioios-&tr=click&_dt=\(kRegexTimestamp)&autocomplete_section=Products&original_query=term_search&autocomplete_key=key_OucJxxrfiTVUQx0C"), builder.create())
        self.constructor.tracking.trackAutocompleteClick(searchTerm: searchTermValue, clickedItemName: itemNameValue)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_Search(){
        let itemNameValue = "item_name"
        let searchTermValue = "term_search"
        
        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackSearch should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/item_name/search?c=cioios-&s=1&_dt=\(kRegexTimestamp)&original_query=term_search&autocomplete_key=key_OucJxxrfiTVUQx0C"), builder.create())
        
        self.constructor.tracking.trackSearch(searchTerm: searchTermValue, itemName: itemNameValue)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultsLoaded(){
        let searchTermValue = "term_search"
        let resultCount = 12

        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&term=term_search&num_results=12"), builder.create())
        
        self.constructor.tracking.trackSearchResultsLoaded(searchTerm: searchTermValue, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }
}
