//
//  TrackPurchaseRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

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
        self.builder = RequestBuilder(apiKey: testACKey)
    }

    func testTrackPurchaseBuilder() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?"))
        XCTAssertTrue(url.contains(encodedCustomerID1), "URL should contain the customer ID[1].")
        XCTAssertTrue(url.contains(encodedCustomerID2), "URL should contain the customer ID[2].")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackPurchaseBuilder_WithSectionName() {
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?"))
        XCTAssertTrue(url.contains(encodedCustomerID1), "URL should contain the customer ID[1].")
        XCTAssertTrue(url.contains(encodedCustomerID2), "URL should contain the customer ID[2].")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }

    func testTrackPurchaseBuilder_WithRevenue(){
        let tracker = CIOTrackPurchaseData(customerIDs: self.customerIDs, sectionName: self.sectionName, revenue: self.revenue)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/TERM_UNKNOWN/purchase?"))
        XCTAssertTrue(url.contains("\(Constants.Track.revenue)=\(self.revenue)"), "URL should contain revenue value.")
    }
}
