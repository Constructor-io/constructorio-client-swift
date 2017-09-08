//
//  TrackConversionRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackConversionRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "testKey123213"
    fileprivate let searchTerm = "test search term"
    fileprivate let itemName = "some item name"
    fileprivate let sectionName = "some section name@"
    fileprivate let revenue = 99999

    fileprivate var encodedSearchTerm: String!
    fileprivate var encodedItemName: String!
    fileprivate var encodedSectionName: String!

    fileprivate var builder: TrackConversionRequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemName = self.itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func testTrackConversionBuilder_onlySearchTerm() {
        let tracker = CIOConversionTracker(searchTerm: searchTerm)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)"))

    }

    func testTrackConversionBuilder_withItemName() {
        let tracker = CIOConversionTracker(searchTerm: searchTerm, itemName: itemName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&item=\(encodedItemName)"))
    }

    func testTrackConversionBuilder_withSectionName() {
        let tracker = CIOConversionTracker(searchTerm: searchTerm, sectionName: sectionName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&autocomplete_section=\(encodedSectionName)"))
    }

    func testTrackConversionBuilder_withRevenue() {
        let tracker = CIOConversionTracker(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&revenue=\(revenue)"))
    }

    func testTrackConversionBuilder_AllFields() {
        let tracker = CIOConversionTracker(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&item=\(encodedItemName)&autocomplete_section=\(encodedSectionName)&revenue=\(revenue)"))
    }
    
}
