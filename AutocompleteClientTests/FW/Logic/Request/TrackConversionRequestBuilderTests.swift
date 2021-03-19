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
    fileprivate let conversionType = "like"
    fileprivate let revenue = 12.45

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
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackConversionBuilder() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackConversionBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix(customBaseURL))
    }

    func testTrackConversionBuilder_WithSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["section"] as? String, sectionName)
    }

    func testTrackConversionBuilder_WithConversionType() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID, conversionType: self.conversionType)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["type"] as? String, conversionType)
    }

    func testTrackConversionBuilder_WithRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["revenue"] as? String, String(revenue))
    }

    func testTrackConversionBuilder_WithSectionNameRevenueAndType() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, sectionName: sectionName, revenue: revenue, conversionType: conversionType)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item id.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["revenue"] as? String, String(revenue))
        XCTAssertEqual(payload?["type"] as? String, conversionType)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
    }
}
