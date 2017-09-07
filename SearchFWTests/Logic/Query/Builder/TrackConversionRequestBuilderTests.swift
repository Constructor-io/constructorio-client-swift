//
//  TrackConversionRequestBuilderTests.swift
//  SearchFWTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorIO

class TrackConversionRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "testKey123213"
    fileprivate let searchTerm = "test search term"
    fileprivate let itemName = "some item name"
    fileprivate let sectionName = "some section name@"
    fileprivate let revenue = 99999

    fileprivate lazy var encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
    fileprivate lazy var encodedItemName = itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    fileprivate lazy var encodedSectionName = sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

    fileprivate var builder: TrackConversionRequestBuilder!

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
