//
//  TrackProductInsightsAgentAnswerFeedbackRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackProductInsightsAgentAnswerFeedbackRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let itemID: String = "10001"
    fileprivate let feedbackLabel: CIOProductInsightsAgentFeedbackLabel = .thumbsUp
    fileprivate let qnaResultID: String = "qna-result-123"
    fileprivate let itemName: String = "Item1"
    fileprivate let variationID: String = "10001-A"
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

    func testTrackProductInsightsAgentAnswerFeedbackBuilder() {
        let tracker = CIOTrackProductInsightsAgentAnswerFeedbackData(itemID: itemID, feedbackLabel: feedbackLabel)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_feedback?"))
        XCTAssertFalse(request.url!.absoluteString.contains("section="))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["feedback_label"] as? String, "thumbs_up")
        XCTAssertNil(payload?["qna_result_id"])
        XCTAssertNil(payload?["item_name"])
        XCTAssertNil(payload?["variation_id"])
        XCTAssertNil(payload?["thread_id"])
        XCTAssertNil(payload?["analytics_tags"])
        XCTAssertNil(payload?["section"])
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentAnswerFeedbackBuilder_WithAllFields() {
        let tracker = CIOTrackProductInsightsAgentAnswerFeedbackData(itemID: itemID, feedbackLabel: feedbackLabel, qnaResultID: qnaResultID, itemName: itemName, variationID: variationID, threadID: threadID, sectionName: sectionName, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.contains("section=Search%20Suggestions"))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["feedback_label"] as? String, "thumbs_up")
        XCTAssertEqual(payload?["qna_result_id"] as? String, qnaResultID)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["thread_id"] as? String, threadID)
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], analyticsTags)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentAnswerFeedbackBuilder_WithThumbsDown() {
        let tracker = CIOTrackProductInsightsAgentAnswerFeedbackData(itemID: itemID, feedbackLabel: .thumbsDown)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        XCTAssertEqual(payload?["feedback_label"] as? String, "thumbs_down")
    }
}
