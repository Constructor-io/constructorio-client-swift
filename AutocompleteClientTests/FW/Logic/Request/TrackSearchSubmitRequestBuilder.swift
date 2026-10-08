//
//  TrackSearchSubmitRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackSearchSubmitRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let searchTerm = "😃test ink[]"
    fileprivate let userInput = "testing#@#??!!asd"
    fileprivate let filters = CIOSearchFilters(groupID: "groupID2")

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    private func payload(_ request: URLRequest) -> [String: Any]? {
        return request.httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
    }

    func testTrackSearchSubmitBuilder() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString
        let payload = self.payload(request)

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(url.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/search?"))
        XCTAssertTrue(url.contains("c=\(Constants.versionString())"), "URL should contain the version string")
        XCTAssertTrue(url.contains("key=\(testACKey)"), "URL should contain the api key")
        XCTAssertFalse(url.contains("original_query"), "URL shouldn't contain the original query")
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
        XCTAssertEqual(payload?["user_input"] as? String, userInput)
    }

    func testTrackSearchSubmitBuilder_OnlySendsSupportedBodyProperties() throws {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, filters: filters, analyticsTags: ["tag1": "value1"])
        builder.build(trackData: tracker)
        let payload = try XCTUnwrap(self.payload(builder.getRequest()), "Expected non-nil body payload")

        XCTAssertEqual(Set(payload.keys), ["search_term", "user_input", "filters", "analytics_tags"], "Body should only contain properties accepted by the endpoint")
    }

    func testTrackSearchSubmitBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("\(customBaseURL)/v2/behavioral_action/search?"))
    }

    func testTrackSearchSubmitBuilder_WithSection() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, section: "Search Suggestions")
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.contains("section=Search%20Suggestions"), "URL should contain the section")
        XCTAssertNil(self.payload(request)?["section"], "Body shouldn't contain the section")
    }

    func testTrackSearchSubmitBuilder_WithoutSection() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput)
        builder.build(trackData: tracker)
        let url = builder.getRequest().url!.absoluteString

        XCTAssertFalse(url.contains("section="), "URL shouldn't contain a section when none is provided")
    }

    func testTrackSearchSubmitBuilder_WithFilters() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, filters: filters)
        builder.build(trackData: tracker)
        let payload = self.payload(builder.getRequest())

        XCTAssertEqual(payload?["filters"] as? [String: String], ["group_id": "groupID2"], "Body should contain the group id in filters when filters are provided")
    }

    func testTrackSearchSubmitBuilder_WithoutFilters() throws {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, filters: nil)
        builder.build(trackData: tracker)
        let payload = try XCTUnwrap(self.payload(builder.getRequest()), "Expected non-nil body payload")

        XCTAssertNil(payload["filters"], "Body shouldn't contain filters when none are provided")
    }

    func testTrackSearchSubmitBuilder_WithAnalyticsTags() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, analyticsTags: ["tag1": "value1", "tag2": "value2"])
        builder.build(trackData: tracker)
        let payload = self.payload(builder.getRequest())

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["tag1": "value1", "tag2": "value2"])
    }

    func testTrackSearchSubmitBuilder_WithoutAnalyticsTags() throws {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, analyticsTags: nil)
        builder.build(trackData: tracker)
        let payload = try XCTUnwrap(self.payload(builder.getRequest()), "Expected non-nil body payload")

        XCTAssertNil(payload["analytics_tags"], "Body shouldn't contain analytics tags when none are provided")
    }

    func testTrackSearchSubmitBuilder_WithEmptyAnalyticsTags() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, analyticsTags: [:])
        builder.build(trackData: tracker)
        let payload = self.payload(builder.getRequest())

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], [:], "Empty analytics tags should be sent as-is")
    }

    func testTrackSearchSubmitBuilder_FiltersOnlyContainGroupID() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, userInput: userInput, filters: filters)
        builder.build(trackData: tracker)
        let sentFilters = self.payload(builder.getRequest())?["filters"] as? [String: Any]

        XCTAssertEqual(Set((sentFilters ?? [:]).keys), ["group_id"])
    }
}

class CIOSearchFiltersTests: XCTestCase {

    func testInit_WithValidGroupID() {
        XCTAssertEqual(CIOSearchFilters(groupID: "group-123")?.groupID, "group-123")
    }

    func testInit_WithEmptyGroupID_ReturnsNil() {
        XCTAssertNil(CIOSearchFilters(groupID: ""))
    }

    func testInit_WithMaxLengthGroupID() {
        let groupID = String(repeating: "a", count: CIOSearchFilters.groupIDMaxLength)
        XCTAssertEqual(CIOSearchFilters(groupID: groupID)?.groupID, groupID)
    }

    func testInit_WithGroupIDOverMaxLength_ReturnsNil() {
        XCTAssertNil(CIOSearchFilters(groupID: String(repeating: "a", count: CIOSearchFilters.groupIDMaxLength + 1)))
    }
}
