//
//  ConstructorIOTrackSearchResultsLoadedTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import OHHTTPStubs
import XCTest

class ConstructorIOTrackSearchResultsLoadedTests: XCTestCase {

    var constructor: ConstructorIO!

    let searchResultsLoadedURL = ConstructorIOTrackSearchResultsLoadedTests.searchResultsLoadedURLWithSection("Products")

    static func searchResultsLoadedURLWithSection(_ section: String) -> String {
        return "https://ac.cnstrc.com/v2/behavioral_action/search_result_load?_dt=\(kRegexTimestamp)&c=\(kRegexVersion)&i=\(kRegexClientID)&key=\(kRegexAutocompleteKey)&s=\(kRegexSession)&section=\(section)&\(TestConstants.defaultSegments)"
    }

    override func setUp() {
        super.setUp()
        self.constructor = TestConstants.testConstructor()
    }

    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }

    func testTrackSearchResultsLoaded() {
        let searchTerm = "term_search"
        let resultCount = 12
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex(searchResultsLoadedURL), builder.create())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoadedWithCustomerIDs() {
        let searchTerm = "term_search"
        let resultCount = 12
        let customerIDs = ["abc", "123"]
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded should send a valid request.", builder: http(200))
        stub(regex(searchResultsLoadedURL), builder.create())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, customerIDs: customerIDs)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoaded_With400() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with 400 should return badRequest CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex(searchResultsLoadedURL), http(400))
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .badRequest, "If tracking call returns status code 400, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded_With500() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with 500 should return internalServerError CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex(searchResultsLoadedURL), http(500))
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .internalServerError, "If tracking call returns status code 500, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded_WithNoConnectivity() {
        let expectation = self.expectation(description: "Calling trackSearchResultsLoaded with no connectvity should return noConnectivity CIOError.")
        let searchTerm = "term_search"
        let resultCount = 12
        stub(regex(searchResultsLoadedURL), noConnectivity())
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { response in
            if let cioError = response.error as? CIOError {
                XCTAssertEqual(cioError.errorType, .noConnection, "If tracking call returns no connectivity, the error should be delegated to the completion handler")
                expectation.fulfill()
            }
        })
        self.wait(for: expectation)
    }

    private func stubCapturingPayload(_ builder: CIOBuilder, _ capture: @escaping ([String: Any]?) -> Void) {
        stub(regex(searchResultsLoadedURL)) { request in
            let payload = request.ohhttpStubs_httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) as? [String: Any] }
            capture(payload)
            return builder.create()(request)
        }
    }

    func testTrackSearchResultsLoaded_WithSection() {
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded with a section should send the section.", builder: http(200))
        stub(regex(ConstructorIOTrackSearchResultsLoadedTests.searchResultsLoadedURLWithSection("Search%20Suggestions")), builder.create())
        self.constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12, section: "Search Suggestions"))
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoaded_WithDefaultItemSectionName() {
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "Content")
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded without a section should fall back to defaultItemSectionName.", builder: http(200))
        stub(regex(ConstructorIOTrackSearchResultsLoadedTests.searchResultsLoadedURLWithSection("Content")), builder.create())
        constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12))
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoaded_WithSectionOverridingDefaultItemSectionName() {
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "Content")
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "A per-call section should win over defaultItemSectionName.", builder: http(200))
        stub(regex(ConstructorIOTrackSearchResultsLoadedTests.searchResultsLoadedURLWithSection("Recipes")), builder.create())
        constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12, section: "Recipes"))
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoaded_WithSectionIsNotInBody() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "section should be sent as a query item only.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12, section: "Products"))
        self.wait(for: builder.expectation)

        XCTAssertNil(payload?["section"])
    }

    func testTrackSearchResultsLoaded_WithSortOptionSelectedFiltersAndResultPage() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded with the new params should send them in the body.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12, sortOption: CIOTrackSortOption(sortBy: "price", sortOrder: .descending), selectedFilters: ["brand": ["Nike", "Adidas"]], resultPage: 2))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["sort_by"] as? String, "price")
        XCTAssertEqual(payload?["sort_order"] as? String, "descending")
        XCTAssertEqual(payload?["selected_filters"] as? [String: [String]], ["brand": ["Nike", "Adidas"]])
        XCTAssertEqual(payload?["result_page"] as? Int, 2)
        XCTAssertNil(payload?["result_offset"])
    }

    func testTrackSearchResultsLoaded_WithResultOffset() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded with a resultOffset should send it in the body.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12, resultOffset: 20))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["result_offset"] as? Int, 20)
        XCTAssertNil(payload?["result_page"])
    }

    func testTrackSearchResultsLoaded_WithoutOptionalParams_OmitsThem() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "Calling trackSearchResultsLoaded without the new params should omit them.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12))
        self.wait(for: builder.expectation)

        for key in ["sort_by", "sort_order", "selected_filters", "result_page", "result_offset"] {
            XCTAssertNil(payload?[key], "\(key) should be absent")
        }
    }

    func testTrackSearchResultsLoaded_RequestOverload_WithItemsAndResultID() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "Calling the request overload should send items and result_id.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12, items: [CIOItem(customerID: "abc", variationID: "var1")], resultID: "result-1"))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["search_term"] as? String, "corn")
        XCTAssertEqual(payload?["result_count"] as? Int, 12)
        XCTAssertEqual(payload?["result_id"] as? String, "result-1")
        let items = payload?["items"] as? [[String: String]]
        XCTAssertEqual(items, [["item_id": "abc", "variation_id": "var1"]])
    }

    func testTrackSearchResultsLoaded_RequestOverload_WithDefaultAndAnalyticsTagsMerged() {
        var payload: [String: Any]?
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultAnalyticsTags: ["default_tag": "default_value", "shared": "default"])
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "Per-call analyticsTags should merge with the defaults.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        constructor.trackSearchResultsLoaded(CIOTrackSearchResultsLoadedRequest(searchTerm: "corn", resultCount: 12, analyticsTags: ["shared": "call", "tag1": "value1"]))
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["default_tag": "default_value", "shared": "call", "tag1": "value1"])
    }

    func testTrackSearchResultsLoaded_DeprecatedOverload_WithCustomerIDs_SendsItems() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "The deprecated overload should map customerIDs to items.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(searchTerm: "corn", resultCount: 12, customerIDs: ["abc", "123"])
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["items"] as? [[String: String]], [["item_id": "abc"], ["item_id": "123"]])
    }

    func testTrackSearchResultsLoaded_DeprecatedOverload_ItemsWinOverCustomerIDs() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "items should win over customerIDs in the deprecated overload.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(searchTerm: "corn", resultCount: 12, customerIDs: ["abc"], items: [CIOItem(customerID: "xyz")])
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["items"] as? [[String: String]], [["item_id": "xyz"]])
    }

    func testTrackSearchResultsLoaded_DeprecatedOverload_UsesDefaultItemSectionName() {
        let config = ConstructorIOConfig(apiKey: TestConstants.testApiKey, defaultItemSectionName: "Content")
        let constructor = TestConstants.testConstructor(config)
        let builder = CIOBuilder(expectation: "The deprecated overload should fall back to defaultItemSectionName.", builder: http(200))
        stub(regex(ConstructorIOTrackSearchResultsLoadedTests.searchResultsLoadedURLWithSection("Content")), builder.create())
        constructor.trackSearchResultsLoaded(searchTerm: "corn", resultCount: 12)
        self.wait(for: builder.expectation)
    }

    func testTrackSearchResultsLoaded_DeprecatedOverload_ForwardsAnalyticsTagsAndResultID() {
        var payload: [String: Any]?
        let builder = CIOBuilder(expectation: "The deprecated overload should forward resultID and analyticsTags.", builder: http(200))
        stubCapturingPayload(builder) { payload = $0 }
        self.constructor.trackSearchResultsLoaded(searchTerm: "corn", resultCount: 12, resultID: "result-1", analyticsTags: ["tag1": "value1"])
        self.wait(for: builder.expectation)

        XCTAssertEqual(payload?["result_id"] as? String, "result-1")
        XCTAssertEqual(payload?["analytics_tags"] as? [String: String], ["tag1": "value1"])
    }
}
