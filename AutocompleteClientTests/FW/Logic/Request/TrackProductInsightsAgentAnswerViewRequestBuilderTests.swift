//
//  TrackProductInsightsAgentAnswerViewRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackProductInsightsAgentAnswerViewRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let itemID: String = "10001"
    fileprivate let question: String = "Why choose this?"
    fileprivate let answerText: String = "This product is made from recycled materials."
    fileprivate let questionTopic: String = "highlights"
    fileprivate let qnaResultID: String = "qna-result-123"
    fileprivate let items: [CIOItem] = [CIOItem(customerID: "10002", itemName: "Item2", variationID: "10002-A", quantity: 3, slCampaignID: "camp1", slCampaignOwner: "owner1"), CIOItem(customerID: "10003")]
    fileprivate let followUpQuestions: [String] = ["What sizes are available?", "Is it machine washable?"]
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

    func testTrackProductInsightsAgentAnswerViewBuilder() {
        let tracker = CIOTrackProductInsightsAgentAnswerViewData(itemID: itemID, question: question, answerText: answerText)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?"))
        XCTAssertFalse(request.url!.absoluteString.contains("section="))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["question"] as? String, question)
        XCTAssertEqual(payload?["answer_text"] as? String, answerText)
        XCTAssertNil(payload?["question_topic"])
        XCTAssertNil(payload?["qna_result_id"])
        XCTAssertNil(payload?["items"])
        XCTAssertNil(payload?["follow_up_questions"])
        XCTAssertNil(payload?["item_name"])
        XCTAssertNil(payload?["variation_id"])
        XCTAssertNil(payload?["thread_id"])
        XCTAssertNil(payload?["analytics_tags"])
        XCTAssertNil(payload?["section"])
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentAnswerViewBuilder_WithAllFields() {
        let tracker = CIOTrackProductInsightsAgentAnswerViewData(itemID: itemID, question: question, answerText: answerText, questionTopic: questionTopic, qnaResultID: qnaResultID, items: items, followUpQuestions: followUpQuestions, itemName: itemName, variationID: variationID, threadID: threadID, sectionName: sectionName, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.contains("section=Search%20Suggestions"))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["question"] as? String, question)
        XCTAssertEqual(payload?["answer_text"] as? String, answerText)
        XCTAssertEqual(payload?["question_topic"] as? String, questionTopic)
        XCTAssertEqual(payload?["qna_result_id"] as? String, qnaResultID)
        XCTAssertEqual(payload?["items"] as? [[String: String]], [["item_id": "10002", "item_name": "Item2", "variation_id": "10002-A", "sl_campaign_id": "camp1", "sl_campaign_owner": "owner1"], ["item_id": "10003"]])
        XCTAssertEqual(payload?["follow_up_questions"] as? [[String: String]], [["value": "What sizes are available?"], ["value": "Is it machine washable?"]])
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["thread_id"] as? String, threadID)
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], analyticsTags)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentAnswerViewBuilder_SendsEmptyAnswerText() {
        let tracker = CIOTrackProductInsightsAgentAnswerViewData(itemID: itemID, question: question, answerText: "")
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        XCTAssertEqual(payload?["answer_text"] as? String, "", "an empty answer_text should be sent")
    }

    func testTrackProductInsightsAgentAnswerViewBuilder_NeverSendsItemQuantity() {
        let items = [CIOItem(customerID: "10002", quantity: 3)]
        let tracker = CIOTrackProductInsightsAgentAnswerViewData(itemID: itemID, question: question, answerText: answerText, items: items)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        let payloadItems = payload?["items"] as? [[String: Any]] ?? []
        XCTAssertEqual(payloadItems.count, 1)
        XCTAssertEqual(payloadItems[0]["item_id"] as? String, "10002")
        XCTAssertNil(payloadItems[0]["quantity"], "quantity should never be sent")
    }

    func testTrackProductInsightsAgentAnswerViewBuilder_CapsItemsAt100() {
        let items = (1...150).map { CIOItem(customerID: "item\($0)") }
        let tracker = CIOTrackProductInsightsAgentAnswerViewData(itemID: itemID, question: question, answerText: answerText, items: items)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        let payloadItems = payload?["items"] as? [[String: String]] ?? []
        XCTAssertEqual(payloadItems.count, 100, "items should be capped at 100")
        XCTAssertEqual(payloadItems[0]["item_id"], "item1")
        XCTAssertEqual(payloadItems[99]["item_id"], "item100")
    }

    func testTrackProductInsightsAgentAnswerViewBuilder_WithExactly100Items() {
        let items = (1...100).map { CIOItem(customerID: "item\($0)") }
        let tracker = CIOTrackProductInsightsAgentAnswerViewData(itemID: itemID, question: question, answerText: answerText, items: items)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        let payloadItems = payload?["items"] as? [[String: String]] ?? []
        XCTAssertEqual(payloadItems.count, 100, "exactly 100 items should pass through unchanged")
        XCTAssertEqual(payloadItems[99]["item_id"], "item100")
    }

    func testTrackProductInsightsAgentAnswerViewBuilder_CapsFollowUpQuestionsAt100() {
        let followUpQuestions = (1...150).map { "Question \($0)?" }
        let tracker = CIOTrackProductInsightsAgentAnswerViewData(itemID: itemID, question: question, answerText: answerText, followUpQuestions: followUpQuestions)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        let payloadFollowUpQuestions = payload?["follow_up_questions"] as? [[String: String]] ?? []
        XCTAssertEqual(payloadFollowUpQuestions.count, 100, "follow_up_questions should be capped at 100")
        XCTAssertEqual(payloadFollowUpQuestions[0]["value"], "Question 1?")
        XCTAssertEqual(payloadFollowUpQuestions[99]["value"], "Question 100?")
    }
}
