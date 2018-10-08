//
//  ABTestingTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class ABTestingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testAutocompleteQueryContainsPassedCells() {
        let keys = ["key1", "key2", "key3"]
        let values = ["value1", "value2", "value3"]
        let cells = keys.enumerated().map { (idx, key) -> CIOABTestCell in
            return CIOABTestCell(key: key, value: values[idx])
        }
        
        var config = AutocompleteConfig(autocompleteKey: TestConstants.testAutocompleteKey)
        config.testCells = cells
        
        let builder = CIOBuilder(expectation: "Calling autocomplete should send a request containing all test cell values.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/test?i=\(kRegexClientID)&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&ef-key1=value1&ef-key2=value2&ef-key3=value3&_dt=\(kRegexTimestamp)"), builder.create())
        let constructor = ConstructorIO(config: config)
        constructor.autocomplete(forQuery: CIOAutocompleteQuery(query: "test")) { (response) in }
        
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchRequestContainsPassedCells() {
        let keys = ["key1", "key2", "key3"]
        let values = ["value1", "value2", "value3"]
        let cells = keys.enumerated().map { (idx, key) -> CIOABTestCell in
            return CIOABTestCell(key: key, value: values[idx])
        }
        
        var config = AutocompleteConfig(autocompleteKey: TestConstants.testAutocompleteKey)
        config.testCells = cells
        
        let builder = CIOBuilder(expectation: "Calling track search should send a request containing all test cell values.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/item/search?i=\(kRegexClientID)&item=item&original_query=term&autocomplete_key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&ef-key1=value1&ef-key2=value2&ef-key3=value3&_dt=\(kRegexTimestamp)"), builder.create())
        let constructor = ConstructorIO(config: config)
        constructor.trackSearch(for: CIOTrackSearchData(searchTerm: "term", itemName: "item"))
        
        self.wait(for: builder.expectation)
    }
    
    func testTrackConversionRequestContainsPassedCells() {
        let keys = ["key1", "key2", "key3"]
        let values = ["value1", "value2", "value3"]
        let cells = keys.enumerated().map { (idx, key) -> CIOABTestCell in
            return CIOABTestCell(key: key, value: values[idx])
        }
        
        var config = AutocompleteConfig(autocompleteKey: TestConstants.testAutocompleteKey)
        config.testCells = cells
        
        let builder = CIOBuilder(expectation: "Calling track conversion should send a request containing all test cell values.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/term/conversion?i=\(kRegexClientID)&item_id=itemID&revenue=10&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&ef-key1=value1&ef-key2=value2&ef-key3=value3&autocomplete_section=section&_dt=\(kRegexTimestamp)"), builder.create())
        let constructor = ConstructorIO(config: config)
        constructor.trackConversion(for: CIOTrackConversionData(searchTerm: "term", itemID: "itemID", sectionName: "section", revenue: 10))
        
        self.wait(for: builder.expectation)
    }
    
    func testTrackInputFocusRequestContainsPassedCells() {
        let keys = ["key1", "key2", "key3"]
        let values = ["value1", "value2", "value3"]
        let cells = keys.enumerated().map { (idx, key) -> CIOABTestCell in
            return CIOABTestCell(key: key, value: values[idx])
        }
        
        var config = AutocompleteConfig(autocompleteKey: TestConstants.testAutocompleteKey)
        config.testCells = cells
        
        let builder = CIOBuilder(expectation: "Calling track input should send a request containing all test cell values.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?action=focus&i=\(kRegexClientID)&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&ef-key1=value1&ef-key2=value2&ef-key3=value3&term=term&_dt=\(kRegexTimestamp)"), builder.create())
        let constructor = ConstructorIO(config: config)
        constructor.trackInputFocus(for: CIOTrackInputFocusData(searchTerm: "term"))
        
        self.wait(for: builder.expectation)
    }
    
    func testTrackAutocompleteClickDataRequestContainsPassedCells() {
        let keys = ["key1", "key2", "key3"]
        let values = ["value1", "value2", "value3"]
        let cells = keys.enumerated().map { (idx, key) -> CIOABTestCell in
            return CIOABTestCell(key: key, value: values[idx])
        }
        
        var config = AutocompleteConfig(autocompleteKey: TestConstants.testAutocompleteKey)
        config.testCells = cells
        
        let builder = CIOBuilder(expectation: "Calling track autocomplete click should send a request containing all test cell values.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/autocomplete/itemName/search?tr=click&i=\(kRegexClientID)&item=itemName&original_query=term&autocomplete_key=key_OucJxxrfiTVUQx0C&c=cioios-&s=1&ef-key1=value1&ef-key2=value2&ef-key3=value3&_dt=\(kRegexTimestamp)"), builder.create())
        let constructor = ConstructorIO(config: config)
        constructor.trackAutocompleteClick(for: CIOTrackAutocompleteClickData(searchTerm: "term", clickedItemName: "itemName"))
        
        self.wait(for: builder.expectation)
    }
    
    func testTrackSearchResultsLoadedRequestContainsPassedCells() {
        let keys = ["key1", "key2", "key3"]
        let values = ["value1", "value2", "value3"]
        let cells = keys.enumerated().map { (idx, key) -> CIOABTestCell in
            return CIOABTestCell(key: key, value: values[idx])
        }
        
        var config = AutocompleteConfig(autocompleteKey: TestConstants.testAutocompleteKey)
        config.testCells = cells
        
        let builder = CIOBuilder(expectation: "Calling track autocomplete click should send a request containing all test cell values.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/behavior?_dt=\(kRegexTimestamp)&action=search-results&i=\(kRegexClientID)&c=cioios-&autocomplete_key=key_OucJxxrfiTVUQx0C&s=1&ef-key1=value1&ef-key2=value2&ef-key3=value3&term=term&num_results=1"), builder.create())
        let constructor = ConstructorIO(config: config)
        constructor.trackSearchResultsLoaded(for: CIOTrackSearchResultsLoadedData(searchTerm: "term", resultCount: 1))
        
        self.wait(for: builder.expectation)
    }
    
}
