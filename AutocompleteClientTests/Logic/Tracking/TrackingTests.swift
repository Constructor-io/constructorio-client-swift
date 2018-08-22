//
//  TrackingTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import Mockingjay
@testable import ConstructorAutocomplete

class TrackingTests: XCTestCase {
    
    var constructor: ConstructorIO!
    
    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(autocompleteKey: TestConstants.testAutocompleteKey, clientID: nil)
        self.mockingjayRemoveStubOnTearDown = true
    }
    
    func testTracking_Conversion(){
        let itemIDValue = "item_ID"
        let revenueValue = 1
        let searchTermValue = "term_search"
        
        // create a matcher that matches the base URL, parameters and path components
        let matcher = CIOMatcher().URL(Constants.Query.baseURLString)
                                  .httpMethod(.get)
                                  .parameter(key: Constants.TrackConversion.itemId, value: itemIDValue)
                                  .parameter(key: Constants.TrackConversion.revenue, value: String(revenueValue))
                                  .pathComponent(Constants.TrackAutocomplete.pathString) // autocomplete path component
                                  .pathComponent(Constants.TrackConversion.type)         // conversion path component
                                  .pathComponent(searchTermValue)                        // searchTerm path component
                                  .create()
        
        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackConversion should send a valid request.", builder: http(200))
        stub(matcher, builder.create())
        
        self.constructor.tracking.trackConversion(itemID: itemIDValue, revenue: revenueValue, searchTerm: searchTermValue)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_AutocompleteClick(){
        let itemNameValue = "item_name"
        let searchTermValue = "term_search"
        
        // create a matcher that matches the base URL, parameters and path components
        let matcher = CIOMatcher().URL(Constants.Query.baseURLString)
            .httpMethod(.get)
            .parameter(key: Constants.TrackAutocompleteResultClicked.originalQuery, value: searchTermValue)
            .pathComponent(Constants.TrackAutocomplete.pathString)                // autocomplete path component
            .pathComponent(Constants.TrackAutocompleteResultClicked.type)         // select path component
            .pathComponent(itemNameValue)                                         // itemName path component
            .create()
        
        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackAutocomplete should send a valid request.", builder: http(200))
        stub(matcher, builder.create())
        
        self.constructor.tracking.trackAutocompleteClick(searchTerm: searchTermValue, clickedItemName: itemNameValue)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_Search(){
        let itemNameValue = "item_name"
        let searchTermValue = "term_search"
        
        // create a matcher that matches the base URL, parameters and path components
        let matcher = CIOMatcher().URL(Constants.Query.baseURLString)
            .httpMethod(.get)
            .parameter(key: Constants.TrackAutocompleteResultClicked.originalQuery, value: searchTermValue)
            .pathComponent(Constants.TrackAutocomplete.pathString)                // autocomplete path component
            .pathComponent(Constants.SearchQuery.pathString)                      // search path component
            .pathComponent(itemNameValue)                                         // itemName path component
            .create()
        
        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackSearch should send a valid request.", builder: http(200))
        stub(matcher, builder.create())
        
        self.constructor.tracking.trackSearch(searchTerm: searchTermValue, itemName: itemNameValue)
        self.wait(for: builder.expectation)
    }
    
    func testTracking_SearchResultsLoaded(){
        let searchTermValue = "term_search"
        let resultCount = 12
        
        // create a matcher that matches the base URL, parameters and path components
        let matcher = CIOMatcher().URL(Constants.Query.baseURLString)
            .httpMethod(.get)
            .parameter(key: Constants.TrackAutocomplete.searchTerm, value: searchTermValue)
            .parameter(key: Constants.AutocompleteQuery.numResults, value: String(resultCount))
            .parameter(key: Constants.TrackAutocomplete.action, value: Constants.TrackAutocomplete.actionSearchResults)
            .pathComponent(Constants.TrackSearch.pathBehavior)                    // behavior path component
            .create()
        
        // return 200 OK on success
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(matcher, builder.create())
        
        self.constructor.tracking.trackSearchResultsLoaded(searchTerm: searchTermValue, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }
}
