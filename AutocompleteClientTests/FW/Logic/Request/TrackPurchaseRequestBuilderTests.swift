//
//  TrackPurchaseRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackPurchaseRequestBuilderTests: XCTestCase {

    fileprivate let revenue: Double = 2.5
    fileprivate let testACKey = "testKey123213"
    fileprivate let customerIDs = ["custIDq3éû qd", "womp womp"]
    fileprivate let sectionName = "some section name@"

    fileprivate var encodedCustomerID1: String = ""
    fileprivate var encodedCustomerID2: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedCustomerID1 = "customer_ids=" + customerIDs[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedCustomerID2 = "customer_ids=" + customerIDs[1].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackPurchaseBuilder() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackPurchaseBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix(customBaseURL))
    }

    func testTrackPurchaseBuilder_WithSectionName() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackPurchaseBuilder_WithRevenue() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName, revenue: self.revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/purchase?"))
    }
}
