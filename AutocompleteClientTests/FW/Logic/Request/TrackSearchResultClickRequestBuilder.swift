//
//  TrackSearchResultClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackSearchResultClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "test search term"
    fileprivate let itemName = "some item name"
    fileprivate let customerID = "custIDq3 qd"
    fileprivate let variationID = "varID123"
    fileprivate let sectionName = "some section name@"

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var encodedItemName: String = ""
    fileprivate var encodedCustomerID: String = ""
    fileprivate var encodedVariationID: String = ""
    fileprivate var encodedSectionName: String = ""

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.encodedItemName = itemName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedCustomerID = customerID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedVariationID = variationID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.encodedSectionName = self.sectionName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
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

    func testTrackSearchResultClickBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackSearchResultClickData(searchTerm: searchTerm, itemName: itemName, customerID: customerID)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix(customBaseURL))
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
        XCTAssertTrue(url.contains("section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }

    func testTrackSearchResultClickBuilder_WithVariationID() {
        let tracker = CIOTrackSearchResultClickData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, sectionName: sectionName, variationID: variationID)

        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/autocomplete/\(encodedSearchTerm)/click_through?"))
        XCTAssertTrue(url.contains("name=\(encodedItemName)"), "URL should contain the item name.")
        XCTAssertTrue(url.contains("customer_id=\(encodedCustomerID)"), "URL should contain the customer ID.")
        XCTAssertTrue(url.contains("variation_id=\(variationID)"), "URL should contain the variation ID.")
        XCTAssertTrue(url.contains("section=\(encodedSectionName)"), "URL should contain the autocomplete section name.")
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
    }

    func testTrackSearchResultClickBuilder_WithSponsoredListingsParams() {
        let slCampaignOwner = "owner789"
        let slCampaignId = "id123"
        let tracker = CIOTrackSearchResultClickData(searchTerm: searchTerm, itemName: itemName, customerID: customerID, sectionName: sectionName, slCampaignID: slCampaignId, slCampaignOwner: slCampaignOwner)

        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.contains("sl_campaign_owner=\(slCampaignOwner)"))
        XCTAssertTrue(url.contains("sl_campaign_id=\(slCampaignId)"))
    }
}
