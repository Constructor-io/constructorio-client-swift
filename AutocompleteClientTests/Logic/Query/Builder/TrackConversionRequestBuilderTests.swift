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
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }

    func testTrackConversionBuilder_withItemName() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(request.url!.absoluteString.contains("item=\(encodedItemName)"), "URL should contain the item name.")
    }

    func testTrackConversionBuilder_withSectionName() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, sectionName: sectionName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
    }
    
    func testTrackConversionBuilder_withRevenue() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
    }

    func testTrackConversionBuilder_AllFields() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        let requestDate = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)!.queryItems!.first { $0.name == "_dt" }!.value!
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
        XCTAssertTrue(request.url!.absoluteString.contains("item=\(encodedItemName)"), "URL should contain the item name.")
        XCTAssertTrue(request.url!.absoluteString.contains("_dt=\(requestDate)"), "URL should contain the request date")
        XCTAssertTrue(request.url!.absoluteString.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }
}
