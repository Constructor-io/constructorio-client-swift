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

    fileprivate let testACKey = "testKey123213"
    fileprivate let customerIDs = ["custIDq3éû qd", "womp womp"]
    fileprivate let sectionName = "some section name@"

    fileprivate var encodedCustomerIDs: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedCustomerIDs = customerIDs.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
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
        XCTAssertTrue(url.contains("customer_ids=\(encodedCustomerIDs)"), "URL should contain the customer ID.")
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
        XCTAssertTrue(url.contains("customer_ids=\(encodedCustomerIDs)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
    }
}
