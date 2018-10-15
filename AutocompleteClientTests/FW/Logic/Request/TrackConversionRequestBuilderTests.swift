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
    fileprivate let customerID = "custIDq3éû qd"
    fileprivate let sectionName = "some section name@"

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedItemName: String = ""
    fileprivate var encodedCustomerID: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = self.searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemName = self.itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedCustomerID = customerID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
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
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackConversionBuilder_WithSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName , customerID: self.customerID, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }
    
    func testTrackConversionBuilder_WithRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, revenue: 9999)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("revenue=9999.00"), "URL should contain the revenue parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackConversionBuilder_WithSectionNameAndRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, sectionName: sectionName, revenue: 12.345)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("revenue=12.35"), "URL should contain the revenue parameter.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }
}
