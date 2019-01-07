//
//  TrackSearchResultClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackSearchResultClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "test search term"
    fileprivate let itemName = "some item name"
    fileprivate let customerID = "custIDq3 qd"
    fileprivate let sectionName = "some section name@"

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedItemName: String = ""
    fileprivate var encodedCustomerID: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemName = itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedCustomerID = customerID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey)
    }

    func testTrackSearchResultClickBuilder() {
        let tracker = CIOTrackSearchResultClickData(searchTerm: searchTerm, itemName: itemName, customerID: customerID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/click_through?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item name.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }

    func testTrackSearchResultClickBuilder_WithSectionName() {
        let tracker = CIOTrackSearchResultClickData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, sectionName: sectionName)

        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/click_through?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item name.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("autocomplete_section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }
}
