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

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedItemName: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: TrackConversionRequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemName = self.itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func testTrackConversionBuilder_onlySearchTerm() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&c=cioios-"))

    }

    func testTrackConversionBuilder_withItemName() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&item=\(encodedItemName)&c=cioios-"))
    }

    func testTrackConversionBuilder_withSectionName() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, sectionName: sectionName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&autocomplete_section=\(encodedSectionName)&c=cioios-"))
    }

    func testTrackConversionBuilder_withRevenue() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&revenue=\(revenue)&c=cioios-"))
    }

    func testTrackConversionBuilder_AllFields() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, URL(string: "https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?autocomplete_key=\(testACKey)&item=\(encodedItemName)&autocomplete_section=\(encodedSectionName)&revenue=\(revenue)&c=cioios-"))
    }
    
    func testTrackConversionBuilder_containsVersionString() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        
        let versionString = Constants.versionString()
        let containsVersionString = request.url!.absoluteString.contains(versionString)
        XCTAssertTrue(containsVersionString, "Track call should contain the version string.")
    }
}
