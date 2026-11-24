//
//  ConstructorIODebugModeEventNameTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIODebugModeEventNameTests: XCTestCase {

    // A call of a tracking method, with the name of the event it has to send
    struct TrackingCall {
        let name: CIOTrackingEventName
        let method: String
        let track: (ConstructorIO) -> Void

        init(_ name: CIOTrackingEventName, _ method: String, _ track: @escaping (ConstructorIO) -> Void) {
            self.name = name
            self.method = method
            self.track = track
        }
    }

    let timeout: TimeInterval = 5.0

    override func setUp() {
        super.setUp()
        // Answers every request, so that no tracking call reaches the network
        stub({ _ in true }, http(200))
    }

    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }

    func testEventNames_HaveStableRawValues() {
        // The raw values are identifiers used outside of the SDK, so they are pinned here literally
        let expectedRawValues = [
            "session_start",
            "input_focus",
            "media_impression_view",
            "media_impression_click",
            "results_impression_view",
            "autocomplete_select",
            "search_submit",
            "search_results_loaded",
            "search_result_click",
            "browse_results_loaded",
            "browse_result_click",
            "recommendation_results_view",
            "recommendation_result_click",
            "conversion",
            "purchase",
            "item_detail_load",
            "quiz_results_loaded",
            "quiz_result_click",
            "quiz_conversion",
            "generic_result_click",
            "agent_submit",
            "agent_result_load_started",
            "agent_result_load_finished",
            "agent_result_click",
            "agent_result_view",
            "agent_search_submit",
            "product_insights_agent_focus",
            "product_insights_agent_out_of_view",
            "product_insights_agent_view",
            "product_insights_agent_views",
            "product_insights_agent_question_click",
            "product_insights_agent_question_submit",
            "product_insights_agent_answer_feedback",
            "product_insights_agent_result_click",
            "product_insights_agent_answer_view"
        ]

        XCTAssertEqual(CIOTrackingEventName.allCases.map { $0.rawValue }, expectedRawValues)
    }

    func testEveryTrackingMethod_SendsAnEventWithItsName() {
        let constructor = TestConstants.testConstructor()
        constructor.config.debugMode = true
        let collector = DebugEventCollector()
        constructor.addDebugEventListener(collector)
        let calls = self.trackingCalls()

        for call in calls {
            let eventsBefore = collector.events.count
            collector.expectation = XCTestExpectation(description: "\(call.method) should produce a debug event.")

            call.track(constructor)
            self.wait(for: [collector.expectation!], timeout: self.timeout)

            XCTAssertEqual(collector.events.count, eventsBefore + 1, "\(call.method) should produce exactly one event.")
            XCTAssertEqual(collector.events.last?.name, call.name, "\(call.method) should send the \(call.name.rawValue) event.")
        }

        XCTAssertEqual(Set(calls.map { $0.name }), Set(CIOTrackingEventName.allCases), "Every event name should be sent by a tracking method.")
        XCTAssertEqual(collector.events.map { $0.sequence }, Array(1...calls.count))
    }

    func testTrackResultsImpressionView_WithoutItems_SendsNoEvent() {
        let constructor = TestConstants.testConstructor()
        constructor.config.debugMode = true
        let collector = DebugEventCollector()
        constructor.addDebugEventListener(collector)
        collector.expectation = XCTestExpectation(description: "The next tracking call should produce a debug event.")

        // A call without items sends no request, so the first event has to be the one of the call after it
        constructor.trackResultsImpressionView(items: [])
        constructor.trackInputFocus(searchTerm: "a")
        self.wait(for: [collector.expectation!], timeout: self.timeout)

        XCTAssertEqual(collector.events.map { $0.name }, [.inputFocus])
        XCTAssertEqual(collector.events.map { $0.sequence }, [1])
    }

    // One call per tracking method, with the event name it has to send. Both trackPurchase methods are listed, as they share a name.
    private func trackingCalls() -> [TrackingCall] {
        let item = CIOItem(customerID: "id-1")
        let question = CIOProductInsightsAgentQuestion(question: "q")
        let timespan = CIOProductInsightsAgentViewTimespan(start: Date(), end: Date())

        return [
            TrackingCall(.sessionStart, "the start of a session", { $0.sessionDidChange(from: 1, to: 2) }),
            TrackingCall(.inputFocus, "trackInputFocus", { $0.trackInputFocus(searchTerm: "a") }),
            TrackingCall(.mediaImpressionView, "trackMediaImpressionView", { $0.trackMediaImpressionView(bannerAdId: "b", placementId: "p") }),
            TrackingCall(.mediaImpressionClick, "trackMediaImpressionClick", { $0.trackMediaImpressionClick(bannerAdId: "b", placementId: "p") }),
            TrackingCall(.resultsImpressionView, "trackResultsImpressionView", { $0.trackResultsImpressionView(items: [item]) }),
            TrackingCall(.autocompleteSelect, "trackAutocompleteSelect", { $0.trackAutocompleteSelect(searchTerm: "a", originalQuery: "a", sectionName: "Products") }),
            TrackingCall(.searchSubmit, "trackSearchSubmit", { $0.trackSearchSubmit(searchTerm: "a", originalQuery: "a") }),
            TrackingCall(.searchResultsLoaded, "trackSearchResultsLoaded", { $0.trackSearchResultsLoaded(searchTerm: "a", resultCount: 1) }),
            TrackingCall(.searchResultClick, "trackSearchResultClick", { $0.trackSearchResultClick(itemName: "n", customerID: "id-1") }),
            TrackingCall(.browseResultsLoaded, "trackBrowseResultsLoaded", { $0.trackBrowseResultsLoaded(filterName: "f", filterValue: "v", resultCount: 1) }),
            TrackingCall(.browseResultClick, "trackBrowseResultClick", { $0.trackBrowseResultClick(customerID: "id-1", filterName: "f", filterValue: "v", resultPositionOnPage: nil) }),
            TrackingCall(.recommendationResultsView, "trackRecommendationResultsView", { $0.trackRecommendationResultsView(podID: "pod") }),
            TrackingCall(.recommendationResultClick, "trackRecommendationResultClick", { $0.trackRecommendationResultClick(podID: "pod", customerID: "id-1") }),
            TrackingCall(.conversion, "trackConversion", { $0.trackConversion(itemName: "n", customerID: "id-1", revenue: nil) }),
            TrackingCall(.purchase, "trackPurchase(customerIDs:)", { $0.trackPurchase(customerIDs: ["id-1"]) }),
            TrackingCall(.purchase, "trackPurchase(items:)", { $0.trackPurchase(items: [item]) }),
            TrackingCall(.itemDetailLoad, "trackItemDetailLoad", { $0.trackItemDetailLoad(customerID: "id-1", itemName: "n") }),
            TrackingCall(.quizResultsLoaded, "trackQuizResultsLoaded", { $0.trackQuizResultsLoaded(quizID: "q", quizVersionID: "v", quizSessionID: "s") }),
            TrackingCall(.quizResultClick, "trackQuizResultClick", { $0.trackQuizResultClick(quizID: "q", quizVersionID: "v", quizSessionID: "s", customerID: "id-1") }),
            TrackingCall(.quizConversion, "trackQuizConversion", { $0.trackQuizConversion(quizID: "q", quizVersionID: "v", quizSessionID: "s", customerID: "id-1") }),
            TrackingCall(.genericResultClick, "trackGenericResultClick", { $0.trackGenericResultClick(itemID: "id-1", itemName: "n") }),
            TrackingCall(.agentSubmit, "trackAgentSubmit", { $0.trackAgentSubmit(intent: "i") }),
            TrackingCall(.agentResultLoadStarted, "trackAgentResultLoadStarted", { $0.trackAgentResultLoadStarted(intent: "i") }),
            TrackingCall(.agentResultLoadFinished, "trackAgentResultLoadFinished", { $0.trackAgentResultLoadFinished(intent: "i", searchResultCount: 1) }),
            TrackingCall(.agentResultClick, "trackAgentResultClick", { $0.trackAgentResultClick(intent: "i", searchResultID: "r") }),
            TrackingCall(.agentResultView, "trackAgentResultView", { $0.trackAgentResultView(intent: "i", searchResultID: "r", numResultsViewed: 1) }),
            TrackingCall(.agentSearchSubmit, "trackAgentSearchSubmit", { $0.trackAgentSearchSubmit(intent: "i", searchTerm: "a", searchResultID: "r") }),
            TrackingCall(.productInsightsAgentFocus, "trackProductInsightsAgentFocus", { $0.trackProductInsightsAgentFocus(CIOTrackProductInsightsAgentFocusRequest(itemID: "id-1")) }),
            TrackingCall(.productInsightsAgentOutOfView, "trackProductInsightsAgentOutOfView", { $0.trackProductInsightsAgentOutOfView(CIOTrackProductInsightsAgentOutOfViewRequest(itemID: "id-1")) }),
            TrackingCall(.productInsightsAgentView, "trackProductInsightsAgentView", { $0.trackProductInsightsAgentView(CIOTrackProductInsightsAgentViewRequest(itemID: "id-1", questions: [question])) }),
            TrackingCall(.productInsightsAgentViews, "trackProductInsightsAgentViews", { $0.trackProductInsightsAgentViews(CIOTrackProductInsightsAgentViewsRequest(itemID: "id-1", questions: [question], viewTimespans: [timespan])) }),
            TrackingCall(.productInsightsAgentQuestionClick, "trackProductInsightsAgentQuestionClick", { $0.trackProductInsightsAgentQuestionClick(CIOTrackProductInsightsAgentQuestionClickRequest(itemID: "id-1", question: "q")) }),
            TrackingCall(.productInsightsAgentQuestionSubmit, "trackProductInsightsAgentQuestionSubmit", { $0.trackProductInsightsAgentQuestionSubmit(CIOTrackProductInsightsAgentQuestionSubmitRequest(itemID: "id-1", question: "q")) }),
            TrackingCall(.productInsightsAgentAnswerFeedback, "trackProductInsightsAgentAnswerFeedback", { $0.trackProductInsightsAgentAnswerFeedback(CIOTrackProductInsightsAgentAnswerFeedbackRequest(itemID: "id-1", feedbackLabel: .thumbsUp)) }),
            TrackingCall(.productInsightsAgentResultClick, "trackProductInsightsAgentResultClick", { $0.trackProductInsightsAgentResultClick(CIOTrackProductInsightsAgentResultClickRequest(itemID: "id-1", question: "q", seedItemID: "seed")) }),
            TrackingCall(.productInsightsAgentAnswerView, "trackProductInsightsAgentAnswerView", { $0.trackProductInsightsAgentAnswerView(CIOTrackProductInsightsAgentAnswerViewRequest(itemID: "id-1", question: "q", answerText: "a")) })
        ]
    }
}
