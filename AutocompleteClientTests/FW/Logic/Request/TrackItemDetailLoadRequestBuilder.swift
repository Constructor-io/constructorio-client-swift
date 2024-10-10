//
//  TrackItemDetailLoadRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackItemDetailLoadRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let itemName = "potato"
    fileprivate let customerID = "custIDq3 qd"
    fileprivate let variationID = "varID123"
    fileprivate let sectionName = "some section name@"
    fileprivate let url = "test.com"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackItemDetailLoadBuilder() {
        let tracker = CIOTrackItemDetailLoadData(itemName: itemName, customerID: customerID, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["url"] as? String, "Not Available")
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
    }
    
    func testTrackItemDetailLoadBuilder_WithAnalyticsTags() {
        let analyticsTags = ["test": "testing", "version": "123"]
        let tracker = CIOTrackItemDetailLoadData(itemName: itemName, customerID: customerID, sectionName: sectionName, analyticsTags: analyticsTags)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]
        let analyticsTagsPayload = payload?["analytics_tags"] as? [String: String] ?? [:]
       

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["url"] as? String, "Not Available")
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
        XCTAssertEqual(analyticsTagsPayload, analyticsTags)
    }

    func testTrackItemDetailLoadBuilder_WithVariationID() {
        let tracker = CIOTrackItemDetailLoadData(itemName: itemName, customerID: customerID, variationID: variationID, sectionName: sectionName, url: url)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["item_id"] as? String, customerID)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["url"] as? String, url)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
    }
}
