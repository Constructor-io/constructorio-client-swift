//
//  TrackProductInsightsAgentViewsRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackProductInsightsAgentViewsRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let itemID: String = "10001"
    fileprivate let questions: [CIOProductInsightsAgentQuestion] = [CIOProductInsightsAgentQuestion(question: "Why choose this?", questionTopic: "highlights"), CIOProductInsightsAgentQuestion(question: "How is this product made?")]
    fileprivate let viewTimespans: [CIOProductInsightsAgentViewTimespan] = [CIOProductInsightsAgentViewTimespan(start: Date(timeIntervalSince1970: 1792636805.125), end: Date(timeIntervalSince1970: 1792636810.5))]
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

    func testTrackProductInsightsAgentViewsBuilder() {
        let tracker = CIOTrackProductInsightsAgentViewsData(itemID: itemID, questions: questions, viewTimespans: viewTimespans)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/product_insights_agent_views?"))
        XCTAssertFalse(request.url!.absoluteString.contains("section="))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["questions"] as? [[String: String]], [["question": "Why choose this?", "question_topic": "highlights"], ["question": "How is this product made?"]])
        XCTAssertEqual(payload?["view_timespans"] as? [[String: String]], [["start": "2026-10-22T02:40:05.125Z", "end": "2026-10-22T02:40:10.500Z"]])
        XCTAssertNil(payload?["item_name"])
        XCTAssertNil(payload?["variation_id"])
        XCTAssertNil(payload?["thread_id"])
        XCTAssertNil(payload?["analytics_tags"])
        XCTAssertNil(payload?["section"])
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackProductInsightsAgentViewsBuilder_WithAllFields() {
        let tracker = CIOTrackProductInsightsAgentViewsData(itemID: itemID, questions: questions, viewTimespans: viewTimespans, itemName: itemName, variationID: variationID, threadID: threadID, sectionName: sectionName, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = self.payload(of: request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.contains("section=Search%20Suggestions"))
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["questions"] as? [[String: String]], [["question": "Why choose this?", "question_topic": "highlights"], ["question": "How is this product made?"]])
        XCTAssertEqual(payload?["view_timespans"] as? [[String: String]], [["start": "2026-10-22T02:40:05.125Z", "end": "2026-10-22T02:40:10.500Z"]])
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["thread_id"] as? String, threadID)
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], analyticsTags)
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
        XCTAssertEqual(payload.map { Set($0.keys) }, ["_dt", "analytics_tags", "beacon", "c", "item_id", "item_name", "key", "questions", "section", "thread_id", "variation_id", "view_timespans"], "the body should only contain keys accepted by the API")
    }

    func testTrackProductInsightsAgentViewsBuilder_FormatsTimespansAsISO8601InUTC() {
        let viewTimespans = [
            CIOProductInsightsAgentViewTimespan(start: Date(timeIntervalSince1970: 0), end: Date(timeIntervalSince1970: 1.5)),
            CIOProductInsightsAgentViewTimespan(start: Date(timeIntervalSince1970: 1792636805), end: Date(timeIntervalSince1970: 1792636810))
        ]
        let tracker = CIOTrackProductInsightsAgentViewsData(itemID: itemID, questions: questions, viewTimespans: viewTimespans)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        XCTAssertEqual(payload?["view_timespans"] as? [[String: String]], [
            ["start": "1970-01-01T00:00:00.000Z", "end": "1970-01-01T00:00:01.500Z"],
            ["start": "2026-10-22T02:40:05.000Z", "end": "2026-10-22T02:40:10.000Z"]
        ])
    }

    func testTrackProductInsightsAgentViewsBuilder_FormatsTimespansToTheNearestMillisecond() {
        let viewTimespans = [
            CIOProductInsightsAgentViewTimespan(start: Date(timeIntervalSince1970: 1792636805.123), end: Date(timeIntervalSince1970: 1792636810.4567)),
            CIOProductInsightsAgentViewTimespan(start: Date(timeIntervalSince1970: 1792636805.009), end: Date(timeIntervalSince1970: 1792636805.015))
        ]
        let tracker = CIOTrackProductInsightsAgentViewsData(itemID: itemID, questions: questions, viewTimespans: viewTimespans)
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        XCTAssertEqual(payload?["view_timespans"] as? [[String: String]], [
            ["start": "2026-10-22T02:40:05.123Z", "end": "2026-10-22T02:40:10.457Z"],
            ["start": "2026-10-22T02:40:05.009Z", "end": "2026-10-22T02:40:05.015Z"]
        ])
    }

    func testTrackProductInsightsAgentViewsBuilder_TimespanFormatterIsPinnedToUTCAndGregorian() {
        // The formatted strings above only match on any host if these are set explicitly, so pin them directly
        let formatter = CIOProductInsightsAgentViewTimespan.dateFormatter
        XCTAssertEqual(formatter.timeZone.secondsFromGMT(), 0)
        XCTAssertEqual(formatter.locale.identifier, "en_US_POSIX")
        XCTAssertEqual(formatter.calendar.identifier, .gregorian)
        XCTAssertEqual(formatter.dateFormat, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }

    func testTrackProductInsightsAgentViewsBuilder_TimespansRoundTripAsISO8601() {
        let start = Date(timeIntervalSince1970: 1792636805.125)
        let end = Date(timeIntervalSince1970: 1792636810.5)
        let tracker = CIOTrackProductInsightsAgentViewsData(itemID: itemID, questions: questions, viewTimespans: [CIOProductInsightsAgentViewTimespan(start: start, end: end)])
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())
        let timespan = (payload?["view_timespans"] as? [[String: String]])?.first

        let parser = ISO8601DateFormatter()
        parser.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let parsedStart = timespan?["start"].flatMap { parser.date(from: $0) }
        let parsedEnd = timespan?["end"].flatMap { parser.date(from: $0) }
        XCTAssertEqual(parsedStart?.timeIntervalSince1970 ?? 0, start.timeIntervalSince1970, accuracy: 0.001)
        XCTAssertEqual(parsedEnd?.timeIntervalSince1970 ?? 0, end.timeIntervalSince1970, accuracy: 0.001)
    }

    func testTrackProductInsightsAgentViewsBuilder_WithEmptyTimespans() {
        let tracker = CIOTrackProductInsightsAgentViewsData(itemID: itemID, questions: questions, viewTimespans: [])
        builder.build(trackData: tracker)
        let payload = self.payload(of: builder.getRequest())

        XCTAssertEqual((payload?["view_timespans"] as? [Any])?.count, 0)
    }
}
