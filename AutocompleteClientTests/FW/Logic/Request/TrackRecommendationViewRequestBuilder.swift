//
//  TrackRecommendationResultsViewRequestBuilder.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackRecommendationResultsViewRequestBuilder: XCTestCase {

    fileprivate let podID = "item_page_1"
    fileprivate let url = "https://constructor.io"
    fileprivate let numResultsViewed = 2
    fileprivate let resultPage = 1
    fileprivate let resultCount = 5
    fileprivate let sectionName = "Content"
    fileprivate let resultID = "83jkd-99a83ja-a8s83k"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: Constants.Query.apiKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackRecommendationResultsViewBuilder() {
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["pod_id"] as? String, podID)
        XCTAssertEqual(payload?["url"] as? String, "Not Available")
    }

    func testTrackRecommendationResultsViewBuilder_WithOptionalParams() {
        let analyticsTags = ["test": "testing", "version": "123"]
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID, analyticsTags: analyticsTags)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["pod_id"] as? String, podID)
        XCTAssertEqual(payload?["url"] as? String, "Not Available")
        XCTAssertEqual(payload?["num_results_viewed"] as? Int, numResultsViewed)
        XCTAssertEqual(payload?["result_page"] as? Int, resultPage)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["result_id"] as? String, resultID)
        XCTAssertEqual(analyticsTagsPayload, analyticsTags)
    }
    
    func testTrackRecommendationResultsViewBuilder_WithCustomerIDsParam() {
        let customerIDs = ["custID1", "custID2", "custID3"]
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, numResultsViewed: numResultsViewed, customerIDs: customerIDs, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: String]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 3)
        XCTAssertEqual(loadedItems[0]["item_id"], customerIDs[0])
    }

    func testTrackRecommendationResultsViewBuilder_WithItemsParam() {
        let items = [
            CIOItem(customerID: "custID1", variationID: "var1"),
            CIOItem(customerID: "custID2", variationID: "var2")
        ]
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID, items: items)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: Any]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 2)
        XCTAssertEqual(loadedItems[0]["item_id"] as? String, items[0].customerID)
        XCTAssertEqual(loadedItems[0]["variation_id"] as? String, items[0].variationID)
        XCTAssertEqual(loadedItems[1]["item_id"] as? String, items[1].customerID)
        XCTAssertEqual(loadedItems[1]["variation_id"] as? String, items[1].variationID)
    }
    
    func testTrackRecommendationResultsViewBuilder_WithItemsParam_NoVariationID() {
        let items = [CIOItem(customerID: "custID1")]
        let data = CIOTrackRecommendationResultsViewData(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID, items: items)
        builder.build(trackData: data)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: Any]] ?? []

        XCTAssertEqual(loadedItems.count, 1)
        XCTAssertEqual(loadedItems[0]["item_id"] as? String, "custID1")
        XCTAssertNil(loadedItems[0]["variation_id"], "variation_id should not be present when nil")
    }

    func testTrackRecommendationResultsViewBuilder_WithSponsoredListingsParams() {
        let slCampaignID = "cmp456"
        let slCampaignOwner = "owner789"
        let items = [CIOItem(customerID: "custID1", variationID: nil, quantity: nil, slCampaignID: slCampaignID, slCampaignOwner: slCampaignOwner)]
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, items: items)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: Any]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 1)
        XCTAssertEqual(loadedItems[0]["item_id"] as? String, "custID1")
        XCTAssertEqual(loadedItems[0]["sl_campaign_id"] as? String, slCampaignID)
        XCTAssertEqual(loadedItems[0]["sl_campaign_owner"] as? String, slCampaignOwner)
    }

    func testTrackRecommendationResultsViewBuilder_WithItemsParamPreferredOverCustomerIDs() {
        let customerIDs = ["custID1", "custID2", "custID3"]
        let items = [CIOItem(customerID: "itemID1", variationID: "var1")]
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, customerIDs: customerIDs, items: items)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: Any]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 1)
        XCTAssertEqual(loadedItems[0]["item_id"] as? String, items[0].customerID)
        XCTAssertEqual(loadedItems[0]["variation_id"] as? String, items[0].variationID)
    }

    func testTrackRecommendationResultsViewBuilder_WithSingleSeedItemID() {
        let seedItemIDs = ["seed-item-123"]
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, seedItemIDs: seedItemIDs)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedSeedItemIDs = payload?["seed_item_ids"] as? [String] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedSeedItemIDs, seedItemIDs)
    }

    func testTrackRecommendationResultsViewBuilder_WithMultipleSeedItemIDs() {
        let seedItemIDs = ["seed-item-123", "seed-item-456", "seed-item-789"]
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, seedItemIDs: seedItemIDs)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedSeedItemIDs = payload?["seed_item_ids"] as? [String] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedSeedItemIDs.count, 3)
        XCTAssertEqual(loadedSeedItemIDs, seedItemIDs)
    }

    func testTrackRecommendationResultsViewBuilder_WithNilSeedItemIDs() {
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, seedItemIDs: nil)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNil(payload?["seed_item_ids"], "Nil seed_item_ids should not be included in the payload")
    }

    func testTrackRecommendationResultsViewBuilder_WithEmptySeedItemIDs() {
        let seedItemIDs: [String] = []
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, seedItemIDs: seedItemIDs)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNil(payload?["seed_item_ids"], "Empty seed_item_ids should not be included in the payload")
    }
}
