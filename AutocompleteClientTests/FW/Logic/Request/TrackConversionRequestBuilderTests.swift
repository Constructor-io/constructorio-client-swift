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
    fileprivate let customerID = "customerID123"
    fileprivate let sectionName = "some section name@"
    fileprivate let revenue: Double = 99999

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedItemName: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemName = self.itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey)
    }
    
    func testTrackConversionBuilder() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName , customerID: self.customerID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackConversionBuilder_withSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName , customerID: self.customerID, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }
    
    func testTrackConversionBuilder_withRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackConversionBuilder_withSectionNameAndRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, sectionName: sectionName, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("revenue=\(revenue)"), "URL should contain the revenue parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }
}
