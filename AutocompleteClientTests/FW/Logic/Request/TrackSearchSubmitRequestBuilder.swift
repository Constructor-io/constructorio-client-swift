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
    fileprivate let originalQuery = "testing#@#??!!asd"
    fileprivate let group = CIOGroup(displayName: "groupName1", groupID: "groupID2", path: "path/to/group")

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    private func payload(_ request: URLRequest) -> [String: Any]? {
        return request.httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
    }

    func testTrackSearchSubmitBuilder() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery)
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
        XCTAssertEqual(payload?["user_input"] as? String, originalQuery)
    }

    func testTrackSearchSubmitBuilder_OnlySendsSupportedBodyProperties() throws {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group, analyticsTags: ["tag1": "value1"])
        builder.build(trackData: tracker)
        let payload = try XCTUnwrap(self.payload(builder.getRequest()), "Expected non-nil body payload")

        XCTAssertEqual(Set(payload.keys), ["search_term", "user_input", "filters", "analytics_tags"], "Body should only contain properties accepted by the endpoint")
    }

    func testTrackSearchSubmitBuilder_WithCustomBaseURL() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery)
        let customBaseURL = "https://custom-base-url.com"
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: customBaseURL)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.hasPrefix("\(customBaseURL)/v2/behavioral_action/search?"))
    }

    func testTrackSearchSubmitBuilder_WithSection() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, section: "Search Suggestions")
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let url = request.url!.absoluteString

        XCTAssertTrue(url.contains("section=Search%20Suggestions"), "URL should contain the section")
        XCTAssertNil(self.payload(request)?["section"], "Body shouldn't contain the section")
    }

    func testTrackSearchSubmitBuilder_WithoutSection() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery)
        builder.build(trackData: tracker)
        let url = builder.getRequest().url!.absoluteString

        XCTAssertFalse(url.contains("section="), "URL shouldn't contain a section when none is provided")
    }

    func testTrackSearchSubmitBuilder_WithGroup() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: group)
        builder.build(trackData: tracker)
        let payload = self.payload(builder.getRequest())

        XCTAssertEqual(payload?["filters"] as? [String: String], ["group_id": "groupID2"], "Body should contain the group id in filters if item in group")
    }

    func testTrackSearchSubmitBuilder_WithoutGroup() throws {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, group: nil)
        builder.build(trackData: tracker)
        let payload = try XCTUnwrap(self.payload(builder.getRequest()), "Expected non-nil body payload")

        XCTAssertNil(payload["filters"], "Body shouldn't contain filters if item outside a group")
    }

    func testTrackSearchSubmitBuilder_WithAnalyticsTags() {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, analyticsTags: ["tag1": "value1", "tag2": "value2"])
        builder.build(trackData: tracker)
        let payload = self.payload(builder.getRequest())

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["tag1": "value1", "tag2": "value2"])
    }

    func testTrackSearchSubmitBuilder_WithoutAnalyticsTags() throws {
        let tracker = CIOTrackSearchSubmitData(searchTerm: searchTerm, originalQuery: originalQuery, analyticsTags: nil)
        builder.build(trackData: tracker)
        let payload = try XCTUnwrap(self.payload(builder.getRequest()), "Expected non-nil body payload")

        XCTAssertNil(payload["analytics_tags"], "Body shouldn't contain analytics tags when none are provided")
    }
}
