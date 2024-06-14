//
//  TrackBrowseResultsLoadedRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackBrowseResultsLoadedRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let filterName = "potato"
    fileprivate let filterValue = "russet"
    fileprivate let url = "Not Available"
    fileprivate let resultCount = 123

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackBrowseResultsLoadedBuilder() {
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"] as? String, filterName)
        XCTAssertEqual(payload?["filter_value"] as? String, filterValue)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
        XCTAssertEqual(payload?["url"] as? String, url)
    }
    
    func testTrackBrowseResultsLoadedBuilder_WithAnalyticsTags() {
        let analyticsTags = ["test": "testing", "version": "123"]
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"] as? String, filterName)
        XCTAssertEqual(payload?["filter_value"] as? String, filterValue)
        XCTAssertEqual(payload?["result_count"] as? Int, resultCount)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
        XCTAssertEqual(payload?["url"] as? String, url)
        XCTAssertEqual(analyticsTagsPayload, analyticsTags)
    }
    
    func testTrackBrowseResultsLoadedBuilder_WithItemsParam() {
        let customerIDs = ["custID1", "custID2", "custID3"]
        let tracker = CIOTrackBrowseResultsLoadedData(filterName: filterName, filterValue: filterValue, resultCount: resultCount, customerIDs: customerIDs)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let loadedItems = payload?["items"] as? [[String: String]] ?? []

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(loadedItems.count, 3)
        XCTAssertEqual(loadedItems[0]["item_id"], customerIDs[0])
    }
}
