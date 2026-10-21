//
//  ConstructorIOTrackProductInsightsAgentAnswerViewTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackProductInsightsAgentAnswerViewTests: XCTestCase {

    var constructor: ConstructorIO!
    let itemID: String = "10001"
    let question: String = "Why choose this?"
    let answerText: String = "This product is made from recycled materials."
    let questionTopic: String = "highlights"
    let qnaResultID: String = "qna-result-123"
    let items: [CIOItem] = [CIOItem(customerID: "10002", itemName: "Item2", variationID: "10002-A", quantity: 3, slCampaignID: "camp1", slCampaignOwner: "owner1"), CIOItem(customerID: "10003")]
    let followUpQuestions: [String] = ["What sizes are available?", "Is it machine washable?"]
    let itemName: String = "Item1"
    let variationID: String = "10001-A"
    let threadID: String = "thread-123"
    let sectionName: String = "Search Suggestions"
    let analyticsTags: [String: String] = ["tag1": "value1"]

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackProductInsightsAgentAnswerView() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentAnswerView should send a valid request with the default section name.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        self.constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
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
        XCTAssertEqual(payload?["section"] as? String, "Products")
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentAnswerView_WithAllFields() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentAnswerView with all fields should send them all.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Search%20Suggestions&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        self.constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText, questionTopic: questionTopic, qnaResultID: qnaResultID, items: items, followUpQuestions: followUpQuestions, itemName: itemName, variationID: variationID, threadID: threadID, sectionName: sectionName, analyticsTags: analyticsTags))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
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
    }

    func testTrackProductInsightsAgentAnswerView_WithSectionFromConfig() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentAnswerView should send a valid request with a section name from config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=section321&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "section321")
        let constructor = TestConstants.testConstructor(config)
        constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText))
        self.wait(for: builder.expectation)
    }

    func testTrackProductInsightsAgentAnswerView_MergesDefaultAnalyticsTags() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentAnswerView should merge defaultAnalyticsTags and analyticsTags.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value", "tag1": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText, analyticsTags: ["tag1": "value1"]))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value", "tag1": "value1"])
    }

    func testTrackProductInsightsAgentAnswerView_WithOnlyDefaultAnalyticsTags() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentAnswerView with only defaultAnalyticsTags should send the default tags.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value"])
    }

    func testTrackProductInsightsAgentAnswerView_SendsEmptyAnswerText() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentAnswerView with an empty answerText should send it.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        self.constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: ""))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["answer_text"] as? String, "", "an empty answer_text should be sent")
    }

    func testTrackProductInsightsAgentAnswerView_CapsItemsAndFollowUpQuestionsAt100() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentAnswerView should cap items and followUpQuestions at 100 and never send quantity.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        let items = (1...150).map { CIOItem(customerID: "item\($0)", quantity: 2) }
        let followUpQuestions = (1...150).map { "Question \($0)?" }
        self.constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText, items: items, followUpQuestions: followUpQuestions))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        let payloadItems = payload?["items"] as? [[String: Any]] ?? []
        XCTAssertEqual(payloadItems.count, 100, "items should be capped at 100")
        XCTAssertTrue(payloadItems.allSatisfy { $0["quantity"] == nil }, "quantity should never be sent")
        XCTAssertEqual((payload?["follow_up_questions"] as? [[String: String]])?.count, 100, "follow_up_questions should be capped at 100")
    }

    func testTrackProductInsightsAgentAnswerView_With400() {
        let expectation = self.expectation(description: "Calling trackProductInsightsAgentAnswerView with 400 should return badRequest CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackProductInsightsAgentAnswerView_With500() {
        let expectation = self.expectation(description: "Calling trackProductInsightsAgentAnswerView with 500 should return internalServerError CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackProductInsightsAgentAnswerView_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackProductInsightsAgentAnswerView with no connectivity should return noConnectivity CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_answer_view?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: itemID, question: question, answerText: answerText), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
