//
//  TrackRecommendationResultClickRequestBuilder.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackRecommendationResultClickRequestBuilder: XCTestCase {

    fileprivate let podID = "item_page_1"
    fileprivate let strategyID = "complementary_items"
    fileprivate let customerID = "p9192830"
    fileprivate let variationID = "v93019283"
    fileprivate let numResultsPerPage = 5
    fileprivate let resultPage = 1
    fileprivate let resultCount = 5
    fileprivate let resultPositionOnPage = 3
    fileprivate let sectionName = "Content"
    fileprivate let resultID = "83jkd-99a83ja-a8s83k"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: Constants.Query.apiKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackRecommendationResultClickBuilder() {
        let recommendationClickData = CIOTrackRecommendationResultClickData(podID: podID, customerID: customerID)
        builder.build(trackData: recommendationClickData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["pod_id"] as? String, podID)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
    }

    func testTrackRecommendationResultClickBuilder_WithOptionalParams() {
        let analyticsTags = ["test": "testing", "version": "123"]
        let recommendationClickData = CIOTrackRecommendationResultClickData(podID: podID, strategyID: strategyID, customerID: customerID, variationID: variationID, numResultsPerPage: numResultsPerPage, resultPage: resultPage, resultCount: resultCount, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, resultID: resultID, analyticsTags: analyticsTags)
        builder.build(trackData: recommendationClickData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["pod_id"] as? String, podID)
        XCTAssertEqual(payload?["strategy_id"] as? String, strategyID)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["num_results_per_page"] as? Int, numResultsPerPage)
        XCTAssertEqual(payload?["result_page"] as? Int, resultPage)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["result_position_on_page"] as? Int, resultPositionOnPage)
        XCTAssertEqual(analyticsTagsPayload, analyticsTags)
    }

    func testTrackRecommendationResultClickBuilder_WithSingleSeedItemID() {
        let seedItemIDs = ["seed-item-123"]
        let recommendationClickData = CIOTrackRecommendationResultClickData(podID: podID, customerID: customerID, seedItemIDs: seedItemIDs)
        builder.build(trackData: recommendationClickData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedSeedItemIDs = payload?["seed_item_ids"] as? [String] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedSeedItemIDs.count, 1)
        XCTAssertEqual(loadedSeedItemIDs[0], seedItemIDs[0])
    }

    func testTrackRecommendationResultClickBuilder_WithMultipleSeedItemIDs() {
        let seedItemIDs = ["seed-item-123", "seed-item-456", "seed-item-789"]
        let recommendationClickData = CIOTrackRecommendationResultClickData(podID: podID, customerID: customerID, seedItemIDs: seedItemIDs)
        builder.build(trackData: recommendationClickData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedSeedItemIDs = payload?["seed_item_ids"] as? [String] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedSeedItemIDs.count, 3)
        XCTAssertEqual(loadedSeedItemIDs, seedItemIDs)
    }

    func testTrackRecommendationResultClickBuilder_WithEmptySeedItemIDs() {
        let seedItemIDs: [String] = []
        let recommendationClickData = CIOTrackRecommendationResultClickData(podID: podID, customerID: customerID, seedItemIDs: seedItemIDs)
        builder.build(trackData: recommendationClickData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertNil(payload?["seed_item_ids"], "Empty seed_item_ids should not be included in the payload")
    }
}
