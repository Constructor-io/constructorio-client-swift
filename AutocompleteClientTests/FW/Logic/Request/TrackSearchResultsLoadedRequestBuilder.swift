//
//  TrackSearchResultsLoadedRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackSearchResultsLoadedRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let resultCount = 123
    fileprivate let customerIDs = ["abc", "123", "doremi"]

    fileprivate var encodedSearchTerm: String = ""
    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackSearchResultsLoadedBuilder() {
        let tracker = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, customerIDs: nil)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/search_result_load?"))
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
        XCTAssertEqual(payload?["url"] as? String, "Not Available")
    }

    func testTrackSearchResultsLoadedBuilderWithCustomerIDs() {
        let tracker = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, customerIDs: customerIDs)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: String]] ?? []

        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/search_result_load?"))
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 3)
        XCTAssertEqual(loadedItems[0]["item_id"], customerIDs[0])
    }
    
    func testSearchResultsLoadedBuilder_WithAnalyticsTags() {
        let analyticsTags = ["test": "testing", "version": "123"]
        let tracker = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(analyticsTagsPayload, analyticsTags)
    }

    func testTrackSearchResultsLoadedBuilder_WithSponsoredListingsParams() {
        let slAdvertiser = "adv123"
        let slCampaignID = "cmp456"
        let slCampaignOwner = "owner789"
        let tracker = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, slAdvertiser: slAdvertiser, slCampaignID: slCampaignID, slCampaignOwner: slCampaignOwner)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["sl_advertiser"] as? String, slAdvertiser)
        XCTAssertEqual(payload?["sl_campaign_id"] as? String, slCampaignID)
        XCTAssertEqual(payload?["sl_campaign_owner"] as? String, slCampaignOwner)
    }

    func testTrackSearchResultsLoadedBuilder_WithItemsParam() {
        let items = [CIOItem(customerID: "abc", variationID: "var1", quantity: 2), CIOItem(customerID: "xyz", quantity: 1)]
        let tracker = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, items: items)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: Any]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 2)
        XCTAssertEqual(loadedItems[0]["item_id"] as? String, items[0].customerID)
        XCTAssertEqual(loadedItems[0]["variation_id"] as? String, items[0].variationID)
    }

    func testTrackSearchResultsLoadedBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackSearchResultsLoadedData(searchTerm: searchTerm, resultCount: resultCount, customerIDs: nil)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix(customBaseURL))
    }
}
