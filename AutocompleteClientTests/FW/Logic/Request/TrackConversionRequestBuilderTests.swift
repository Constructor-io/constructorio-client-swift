//
//  TrackConversionRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackConversionRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "testKey123213"
    fileprivate let searchTerm = "test search term"
    fileprivate let itemName = "some item name"
    fileprivate let customerID = "custIDq3éû qd"
    fileprivate let variationID = "varID123"
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
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
    }

    func testTrackConversionBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertTrue(url.hasPrefix(customBaseURL))
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
    }

    func testTrackConversionBuilder_WithSectionName() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("section=\(encodedSectionName)"), "URL should contain the section.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
    }

    func testTrackConversionBuilder_WithVariationID() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID, sectionName: sectionName, variationID: self.variationID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("section=\(encodedSectionName)"), "URL should contain the section.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
    }

    func testTrackConversionBuilder_WithConversionType() {
        let tracker = CIOTrackConversionData(searchTerm: self.searchTerm, itemName: self.itemName, customerID: self.customerID, conversionType: self.conversionType)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["type"] as? String, conversionType)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
    }

    func testTrackConversionBuilder_WithRevenue() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, revenue: revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["revenue"] as? String, String(revenue))
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
    }

    func testTrackConversionBuilder_WithSectionNameRevenueAndType() {
        let tracker = CIOTrackConversionData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, sectionName: sectionName, revenue: revenue, conversionType: conversionType)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/conversion?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("section=\(encodedSectionName)"), "URL should contain the section.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["revenue"] as? String, String(revenue))
        XCTAssertEqual(payload?["type"] as? String, conversionType)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
    }
}
