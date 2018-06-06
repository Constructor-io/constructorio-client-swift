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
    
    func testTrackConversionBuilder_onlySearchTerm_hasGetHTTPMethod() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testTrackConversionBuilder_onlySearchTerm_hasCorrectBaseURL() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
    }
    
    func testTrackConversionBuilder_onlySearchTerm_containsAutocompleteKey() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
    }
    
    func testTrackConversionBuilder_onlySearchTerm_containsVersionString() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }

    func testTrackConversionBuilder_withItemName_hasGetHTTPMethod() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testTrackConversionBuilder_withItemName_containsAutocompleteKey() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
    }
    
    func testTrackConversionBuilder_withItemName_containsVersionString() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }
    
    func testTrackConversionBuilder_withItemName_containsItemName() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("item=\(encodedItemName)"), "URL should contain the item name.")
    }

    func testTrackConversionBuilder_withSectionName_hasGetHTTPMethod() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, sectionName: sectionName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testTrackConversionBuilder_withSectionName_containsAutocompleteKey() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, sectionName: sectionName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
    }
    
    func testTrackConversionBuilder_withSectionName_containsVersionString() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, sectionName: sectionName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }
    
    func testTrackConversionBuilder_withSectionName_containsAutocompleteSectionName() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, sectionName: sectionName)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
    }
    
    func testTrackConversionBuilder_withRevenue_hasGetHTTPMethod() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testTrackConversionBuilder_withRevenue_hasCorrectBaseURL() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
    }
    
    func testTrackConversionBuilder_withRevenue_containsAutocompleteKey() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
    }
    
    func testTrackConversionBuilder_withRevenue_containsRevenueField() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
    }
    
    func testTrackConversionBuilder_withRevenue_containsVersionString() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }

    func testTrackConversionBuilder_AllFields_hasGetHTTPMethod() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertEqual(request.httpMethod, "GET")
    }
    
    func testTrackConversionBuilder_AllFields_hasCorrectBaseURL() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
    }
    
    func testTrackConversionBuilder_AllFields_containsAutocompleteKey() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_key=\(testACKey)"), "URL should contain the autocomplete key.")
    }
    
    func testTrackConversionBuilder_AllFields_hasItemName() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("item=\(encodedItemName)"), "URL should contain the item name.")
    }
    
    func testTrackConversionBuilder_AllFields_hasRevenueField() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
    }
    
    func testTrackConversionBuilder_AllFields_hasAutocompleteSection() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
    }
    
    func testTrackConversionBuilder_AllFields_hasVersionString() {
        let tracker = CIOConversionTrackData(searchTerm: searchTerm, itemName: itemName, sectionName: sectionName, revenue: revenue)
        builder = TrackConversionRequestBuilder(tracker: tracker, autocompleteKey: testACKey)
        let request = builder.getRequest()
        XCTAssertTrue(request.url!.absoluteString.contains("c=cioios-"), "URL should contain the version string.")
    }
}
