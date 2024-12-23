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

    func testTrackRecommendationResultClickBuilder_WithOptionalParams() {
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
    
    func testTrackRecommendationResultClickBuilder_WithItemsParam() {
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
}
