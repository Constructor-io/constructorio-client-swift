//
//  ConstructorIOTrackSearchSubmitTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackSearchSubmitTests: XCTestCase {

    var constructor: ConstructorIO!

    let searchSubmitURL = ConstructorIOTrackSearchSubmitTests.searchSubmitURLWithSection("Products")

    static func searchSubmitURLWithSection(_ section: String) -> String {
        return "https://ac.cnstrc.com/v2/behavioral_action/search?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=\(section)&\(TestConstants.defaultSegments)"
    }

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    private func stubCapturingPayload(_ builder: CIOBuilder, _ capture: @escaping ([String: Any]?) -> Void) {
        stub(regex(searchSubmitURL)) { request in
            let payload = request.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
            capture(payload)
            return builder.create()(request)
        }
    }

    func testTrackSearchSubmit() throws {
        var capturedPayload: [String: Any]?
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit should send a valid request.", builder: http(200))
        stubCapturingPayload(builder) { capturedPayload = $0 }
        self.constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "cor"))
        self.wait(for: builder.expectation)

        let payload = try XCTUnwrap(capturedPayload, "Expected non-nil body payload")
        XCTAssertEqual(payload["search_term"] as? String, "corn")
        XCTAssertEqual(payload["user_input"] as? String, "cor")
        XCTAssertNil(payload["filters"], "filters should not be present when no filters are provided")
        XCTAssertNil(payload["analytics_tags"], "analytics_tags should not be present when none are provided")
    }

    func testTrackSearchSubmit_WithFilters() {
        var payload: [String: Any]?
        let filters = CIOTrackSearchSubmitFilters(groupID: "group-123")
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with filters should send the group id in filters.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn", filters: filters))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["filters"] as? [String: String], ["group_id": "group-123"])
    }

    func testTrackSearchSubmit_WithSection() {
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with a section should send the section.", builder: http(200))
        stub(regex(ConstructorIOTrackSearchSubmitTests.searchSubmitURLWithSection("Search%20Suggestions")), builder.create())
        self.constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn", section: "Search Suggestions"))
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_WithDefaultItemSectionName() {
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "Content")
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit without a section should fall back to defaultItemSectionName.", builder: http(200))
        stub(regex(ConstructorIOTrackSearchSubmitTests.searchSubmitURLWithSection("Content")), builder.create())
        constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn"))
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_WithDefaultAnalyticsTagsOnly() {
        var payload: [String: Any]?
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with only defaultAnalyticsTags should send the default tags.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn"))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value"])
    }

    func testTrackSearchSubmit_WithAnalyticsTagsOnly() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with only analyticsTags should send the passed tags.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn", analyticsTags: ["tag1": "value1", "tag2": "value2"]))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["tag1": "value1", "tag2": "value2"])
    }

    func testTrackSearchSubmit_WithDefaultAndAnalyticsTagsMerged() {
        var payload: [String: Any]?
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with both should merge defaultAnalyticsTags and analyticsTags.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn", analyticsTags: ["tag1": "value1"]))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value", "tag1": "value1"])
    }

    func testTrackSearchSubmit_WithAnalyticsTagsOverridingDefault() {
        var payload: [String: Any]?
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Calling trackSearchSubmit with analyticsTags overriding a defaultAnalyticsTags key should send only the per-request value.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn", analyticsTags: ["default_tag": "overridden_value"]))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "overridden_value"])
    }

    func testTrackSearchSubmit_With400() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with 400 should return badRequest CIOError.")
        stub(regex(searchSubmitURL), http(400))
        self.constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn"), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit_With500() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with 500 should return internalServerError CIOError.")
        stub(regex(searchSubmitURL), http(500))
        self.constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn"), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackSearchSubmit with no connectvity should return noConnectivity CIOError.")
        stub(regex(searchSubmitURL), noConnectivity())
        self.constructor.trackSearchSubmit(CIOTrackSearchSubmitRequest(searchTerm: "corn", userInput: "corn"), completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    // Tests for Deprecated Overload
    func testTrackSearchSubmit_DeprecatedOverload_WithGroup() {
        var payload: [String: Any]?
        let group = CIOGroup(displayName: "Canned Goods", groupID: "group-123", path: nil)
        let builder = CIOBuilder(expectation: "Deprecated trackSearchSubmit should forward the group id as filters.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "cor", group: group, analyticsTags: ["tag1": "value1"])
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["search_term"] as? String, "corn")
        XCTAssertEqual(payload?["user_input"] as? String, "cor")
        XCTAssertEqual(payload?["filters"] as? [String: String], ["group_id": "group-123"])
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["tag1": "value1"])
    }

    func testTrackSearchSubmit_DeprecatedOverload_WithoutOptionals() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "Deprecated trackSearchSubmit with only required params should send only required body fields.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "cor")
        self.wait(for: builder.expectation)

        XCTAssertNotNil(payload)
        XCTAssertNil(payload?["filters"])
        XCTAssertNil(payload?["analytics_tags"])
    }

    func testTrackSearchSubmit_DeprecatedOverload_UsesDefaultItemSectionName() {
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "Content")
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Deprecated trackSearchSubmit should use defaultItemSectionName.", builder: http(200))
        stub(regex(ConstructorIOTrackSearchSubmitTests.searchSubmitURLWithSection("Content")), builder.create())
        constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "corn")
        self.wait(for: builder.expectation)
    }

    func testTrackSearchSubmit_DeprecatedOverload_WithDefaultAndAnalyticsTagsMerged() {
        var payload: [String: Any]?
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value"])
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Deprecated trackSearchSubmit should merge defaultAnalyticsTags with analyticsTags.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "corn", analyticsTags: ["tag1": "value1"])
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value", "tag1": "value1"])
    }

    func testTrackSearchSubmit_DeprecatedOverload_ForwardsCompletionHandler() {
        let expectation = self.expectation(description: "Deprecated trackSearchSubmit should delegate errors to the completion handler.")
        stub(regex(searchSubmitURL), http(400))
        self.constructor.trackSearchSubmit(searchTerm: "corn", originalQuery: "corn", completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest)
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }
}
