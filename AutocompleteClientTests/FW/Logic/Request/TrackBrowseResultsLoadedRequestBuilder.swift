//
//  TrackBrowseResultsLoadedRequestBuilderTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackBrowseResultsLoadedRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let filterName = "potato"
    fileprivate let filterValue = "russet"
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
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: String]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"], filterName)
        XCTAssertEqual(payload?["filter_value"], filterValue)
        XCTAssertEqual(payload?["result_count"], String(resultCount))
        XCTAssertEqual(payload?["key"], testACKey)
        XCTAssertEqual(payload?["c"], "cioios-")
        XCTAssertEqual(payload?["url"], "Not Available")
    }
}
