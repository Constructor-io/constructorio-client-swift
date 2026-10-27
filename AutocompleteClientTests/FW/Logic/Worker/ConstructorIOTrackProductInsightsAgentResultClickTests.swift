//
//  ConstructorIOTrackProductInsightsAgentResultClickTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackProductInsightsAgentResultClickTests: XCTestCase {

    var constructor: ConstructorIO!
    let itemID: String = "10002"
    let question: String = "Why choose this?"
    let seedItemID: String = "10001"
    let position: Int = 3
    let seedItemName: String = "Item1"
    let seedVariationID: String = "10001-A"
    let qnaResultID: String = "qna-result-123"
    let itemName: String = "Item2"
    let variationID: String = "10002-A"
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

    func testTrackProductInsightsAgentResultClick() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentResultClick should send a valid request with the default section name.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        self.constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
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
        XCTAssertEqual(payload?["section"] as? String, "Products")
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentResultClick_WithAllFields() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentResultClick with all fields should send them all.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Search%20Suggestions&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        self.constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID, position: position, seedItemName: seedItemName, seedVariationID: seedVariationID, qnaResultID: qnaResultID, itemName: itemName, variationID: variationID, threadID: threadID, sectionName: sectionName, analyticsTags: analyticsTags))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
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
    }

    func testTrackProductInsightsAgentResultClick_WithSectionFromConfig() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentResultClick should send a valid request with a section name from config.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=section321&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "section321")
        let constructor = TestConstants.testConstructor(config)
        constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID))
        self.wait(for: builder.expectation)
    }

    func testTrackProductInsightsAgentResultClick_RequestSectionOverridesConfig() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentResultClick should prefer the request section name over the config default.", builder: http(200))
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Search%20Suggestions&\(TestConstants.defaultSegments)"), builder.create())
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "section321")
        let constructor = TestConstants.testConstructor(config)
        constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID, sectionName: sectionName))
        self.wait(for: builder.expectation)
    }

    func testTrackProductInsightsAgentResultClick_MergesDefaultAnalyticsTags() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentResultClick should merge defaultAnalyticsTags and analyticsTags.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value", "tag1": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID, analyticsTags: ["tag1": "value1"]))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value", "tag1": "value1"])
    }

    func testTrackProductInsightsAgentResultClick_WithOnlyDefaultAnalyticsTags() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentResultClick with only defaultAnalyticsTags should send the default tags.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value"])
    }

    func testTrackProductInsightsAgentResultClick_SendsPositionZero() {
        let builder = CIOBuilder(expectation: "Calling trackProductInsightsAgentResultClick with position 0 should send it.", builder: http(200))
        var capturedRequest: URLRequest?
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)")) { request in
            capturedRequest = request
            return builder.create()(request)
        }
        self.constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID, position: 0))
        self.wait(for: builder.expectation)

        let payload = capturedRequest?.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
        XCTAssertNotNil(payload, "Request body should contain valid JSON")
        XCTAssertEqual(payload?["position"] as? Int, 0, "position 0 should be sent")
    }

    func testTrackProductInsightsAgentResultClick_With400() {
        let expectation = self.expectation(description: "Calling trackProductInsightsAgentResultClick with 400 should return badRequest CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(400))
        self.constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackProductInsightsAgentResultClick_With500() {
        let expectation = self.expectation(description: "Calling trackProductInsightsAgentResultClick with 500 should return internalServerError CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), http(500))
        self.constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackProductInsightsAgentResultClick_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackProductInsightsAgentResultClick with no connectivity should return noConnectivity CIOError.")
        stub(regex("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_result_click?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=Products&\(TestConstants.defaultSegments)"), noConnectivity())
        self.constructor.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: itemID, question: question, seedItemID: seedItemID), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
