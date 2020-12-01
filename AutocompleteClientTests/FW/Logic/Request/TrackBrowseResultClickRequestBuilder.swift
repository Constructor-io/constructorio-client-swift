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
    fileprivate let customerID = "custIDq3 qd"
    fileprivate let sectionName = "some section name@"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackBrowseResultClickBuilder() {
        let tracker = CIOTrackBrowseResultClickData(filterName: filterName, filterValue: filterValue, customerID: customerID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: String]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["filter_name"], filterName)
        XCTAssertEqual(payload?["filter_value"], filterValue)
        XCTAssertEqual(payload?["item_id"], customerID)
        XCTAssertEqual(payload?["key"], testACKey)
        XCTAssertEqual(payload?["c"], "cioios-")
    }
}
