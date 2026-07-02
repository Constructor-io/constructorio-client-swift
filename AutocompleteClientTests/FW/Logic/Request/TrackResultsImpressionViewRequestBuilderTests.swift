//
//  TrackResultsImpressionViewRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackResultsImpressionViewRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "testKey123213"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackResultsImpressionViewBuilder() {
        let items = [CIOItem(customerID: "item-1", itemName: "Item One")]
        let tracker = CIOTrackResultsImpressionViewData(items: items)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/impression_view?"))
        XCTAssertTrue(url.contains("c=cioios-"), "URL should contain the version string.")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key.")
        XCTAssertEqual(payload?["beacon"] as? Bool, true)

        let itemsArray = payload?["items"] as? [[String: Any]] ?? []
        XCTAssertEqual(itemsArray.count, 1)
        XCTAssertEqual(itemsArray[0]["item_id"] as? String, "item-1")
        XCTAssertEqual(itemsArray[0]["item_name"] as? String, "Item One")
    }

    func testTrackResultsImpressionViewBuilder_WithMultipleItems() {
        let items = [
            CIOItem(customerID: "item-1", itemName: "Item One", variationID: "var-1"),
            CIOItem(customerID: "item-2", itemName: "Item Two", slCampaignID: "camp-1", slCampaignOwner: "owner-a")
        ]
        let tracker = CIOTrackResultsImpressionViewData(items: items)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        let itemsArray = payload?["items"] as? [[String: Any]] ?? []
        XCTAssertEqual(itemsArray.count, 2)
        XCTAssertEqual(itemsArray[0]["item_id"] as? String, "item-1")
        XCTAssertEqual(itemsArray[0]["variation_id"] as? String, "var-1")
        XCTAssertEqual(itemsArray[1]["item_id"] as? String, "item-2")
        XCTAssertEqual(itemsArray[1]["sl_campaign_id"] as? String, "camp-1")
        XCTAssertEqual(itemsArray[1]["sl_campaign_owner"] as? String, "owner-a")
    }

    func testTrackResultsImpressionViewBuilder_WithSearchTerm() {
        let items = [CIOItem(customerID: "item-1", itemName: "Item One")]
        let tracker = CIOTrackResultsImpressionViewData(items: items, searchTerm: "shoes")
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(payload?["search_term"] as? String, "shoes")
    }

    func testTrackResultsImpressionViewBuilder_WithFilters() {
        let items = [CIOItem(customerID: "item-1", itemName: "Item One")]
        let tracker = CIOTrackResultsImpressionViewData(items: items, filterName: "category_id", filterValue: "shoes-123")
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(payload?["filter_name"] as? String, "category_id")
        XCTAssertEqual(payload?["filter_value"] as? String, "shoes-123")
    }

    func testTrackResultsImpressionViewBuilder_WithCustomBaseURL() {
        let customBaseURL = "https://custom-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        let items = [CIOItem(customerID: "item-1", itemName: "Item One")]
        let tracker = CIOTrackResultsImpressionViewData(items: items)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("\(customBaseURL)/v2/behavioral_action/impression_view?"))
    }
}
