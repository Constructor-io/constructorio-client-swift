//
//  TrackProductInsightsAgentResultClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackProductInsightsAgentResultClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let itemID: String = "10002"
    fileprivate let question: String = "Why choose this?"
    fileprivate let seedItemID: String = "10001"
    fileprivate let position: Int = 3
    fileprivate let seedItemName: String = "Item1"
    fileprivate let seedVariationID: String = "10001-A"
    fileprivate let qnaResultID: String = "qna-result-123"
    fileprivate let itemName: String = "Item2"
    fileprivate let variationID: String = "10002-A"
    fileprivate let threadID: String = "thread-123"
    fileprivate let sectionName: String = "Search Suggestions"
    fileprivate let analyticsTags: [String: String] = ["tag1": "value1"]

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    fileprivate func payload(of request: URLRequest) -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
    }

    func testTrackProductInsightsAgentResultClickBuilder() {
        let tracker = CIOTrackProductInsightsAgentResultClickData(itemID: itemID, question: question, seedItemID: seedItemID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?"))
        XCTAssertFalse(request.url!.absoluteString.contains("section="))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["question"] as? String, question)
        XCTAssertEqual(payload?["seed_item_id"] as? String, seedItemID)
        XCTAssertNil(payload?["position"])
        XCTAssertNil(payload?["seed_item_name"])
        XCTAssertNil(payload?["seed_variation_id"])
        XCTAssertNil(payload?["qna_result_id"])
        XCTAssertNil(payload?["item_name"])
        XCTAssertNil(payload?["variation_id"])
        XCTAssertNil(payload?["thread_id"])
        XCTAssertNil(payload?["analytics_tags"])
        XCTAssertNil(payload?["section"])
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentResultClickBuilder_WithAllFields() {
        let tracker = CIOTrackProductInsightsAgentResultClickData(itemID: itemID, question: question, seedItemID: seedItemID, position: position, seedItemName: seedItemName, seedVariationID: seedVariationID, qnaResultID: qnaResultID, itemName: itemName, variationID: variationID, threadID: threadID, sectionName: sectionName, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.contains("section=Search%20Suggestions"))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["question"] as? String, question)
        XCTAssertEqual(payload?["seed_item_id"] as? String, seedItemID)
        XCTAssertEqual(payload?["position"] as? Int, position)
        XCTAssertEqual(payload?["seed_item_name"] as? String, seedItemName)
        XCTAssertEqual(payload?["seed_variation_id"] as? String, seedVariationID)
        XCTAssertEqual(payload?["qna_result_id"] as? String, qnaResultID)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["thread_id"] as? String, threadID)
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], analyticsTags)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
        XCTAssertEqual(payload.map { Set($0.keys) }, ["_dt", "analytics_tags", "beacon", "c", "item_id", "item_name", "key", "position", "qna_result_id", "question", "section", "seed_item_id", "seed_item_name", "seed_variation_id", "thread_id", "variation_id"], "the body should only contain keys accepted by the API")
    }

    func testTrackProductInsightsAgentResultClickBuilder_SendsPositionZero() {
        let tracker = CIOTrackProductInsightsAgentResultClickData(itemID: itemID, question: question, seedItemID: seedItemID, position: 0)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        XCTAssertEqual(payload?["position"] as? Int, 0, "position 0 should be sent")
    }
}
