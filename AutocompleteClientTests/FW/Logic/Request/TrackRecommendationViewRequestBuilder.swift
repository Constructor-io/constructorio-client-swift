//
//  TrackRecommendationResultsViewRequestBuilder.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackRecommendationResultsViewRequestBuilder: XCTestCase {

    fileprivate let podID = "item_page_1"
    fileprivate let url = "https://constructor.io";
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
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, url: url)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["pod_id"] as? String, podID)
        XCTAssertEqual(payload?["url"] as? String, url)
    }
    
    func testTrackRecommendationResultClickBuilder_WithOptionalParams() {
        let recommendationViewData = CIOTrackRecommendationResultsViewData(podID: podID, url: url, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID)
        builder.build(trackData: recommendationViewData)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["pod_id"] as? String, podID)
        XCTAssertEqual(payload?["url"] as? String, url)
        XCTAssertEqual(payload?["num_results_viewed"] as? Int, numResultsViewed)
        XCTAssertEqual(payload?["result_page"] as? Int, resultPage)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["result_id"] as? String, resultID)
    }
}
