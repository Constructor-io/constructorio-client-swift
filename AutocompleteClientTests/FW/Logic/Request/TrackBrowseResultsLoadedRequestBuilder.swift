//
//  TrackBrowseResultsLoadedRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackBrowseResultsLoadedRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let filterName = "potato"
    fileprivate let filterValue = "russet"
    fileprivate let url = "Not Available"
    fileprivate let resultCount = 123

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackBrowseResultsLoadedBuilder() {
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"] as? String, filterName)
        XCTAssertEqual(payload?["filter_value"] as? String, filterValue)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
        XCTAssertEqual(payload?["url"] as? String, url)
    }
    
    func testTrackBrowseResultsLoadedBuilder_WithAnalyticsTags() {
        let analyticsTags = ["test": "testing", "version": "123"]
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"] as? String, filterName)
        XCTAssertEqual(payload?["filter_value"] as? String, filterValue)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
        XCTAssertEqual(payload?["url"] as? String, url)
        XCTAssertEqual(analyticsTagsPayload, analyticsTags)
    }
    
    func testTrackBrowseResultsLoadedBuilder_WithCustomerIdParam() {
        let customerIDs = ["custID1", "custID2", "custID3"]
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, customerIDs: customerIDs)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: String]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 3)
        XCTAssertEqual(loadedItems[0]["item_id"], customerIDs[0])
    }
    
    func testTrackBrowseResultsLoadedBuilder_WithItemsParam() {
        let items = [
            CIOItem(customerID: "custID1", variationID: "var1", quantity: 2),
            CIOItem(customerID: "custID2", quantity: 1)
        ]
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, items: items)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: Any]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 2)
        XCTAssertEqual(loadedItems[0]["item_id"] as? String, items[0].customerID)
        XCTAssertEqual(loadedItems[0]["variation_id"] as? String, items[0].variationID)
    }
    
    func testTrackBrowseResultsLoadedBuilder_WithSponsoredListingsParams() {
        let slAdvertiser = "adv123"
        let slCampaignID = "cmp456"
        let slCampaignOwner = "owner789"
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, slAdvertiser: slAdvertiser, slCampaignID: slCampaignID, slCampaignOwner: slCampaignOwner)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["sl_advertiser"] as? String, slAdvertiser)
        XCTAssertEqual(payload?["sl_campaign_id"] as? String, slCampaignID)
        XCTAssertEqual(payload?["sl_campaign_owner"] as? String, slCampaignOwner)
    }
}
