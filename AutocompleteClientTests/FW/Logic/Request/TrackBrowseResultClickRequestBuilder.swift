//
//  TrackBrowseResultClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
@testable import ConstructorAutocomplete

class TrackBrowseResultClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let filterName = "potato"
    fileprivate let filterValue = "russet"
    fileprivate let resultPositionOnPage = 3
    fileprivate let customerID = "custIDq3 qd"
    fileprivate let variationID = "varID123"
    fileprivate let sectionName = "some section name@"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackBrowseResultClickBuilder() {
        let tracker = CIOTrackBrowseResultClickData(filterName: filterName, filterValue: filterValue, customerID: customerID, resultPositionOnPage: resultPositionOnPage)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"] as? String, filterName)
        XCTAssertEqual(payload?["filter_value"] as? String, filterValue)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["result_position_on_page"] as? Int, resultPositionOnPage)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
    }

    func testTrackBrowseResultClickBuilder_WithVariationID() {
        let tracker = CIOTrackBrowseResultClickData(filterName: filterName, filterValue: filterValue, customerID: customerID, resultPositionOnPage: resultPositionOnPage, variationID: variationID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"] as? String, filterName)
        XCTAssertEqual(payload?["filter_value"] as? String, filterValue)
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["result_position_on_page"] as? Int, resultPositionOnPage)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
    }
}
