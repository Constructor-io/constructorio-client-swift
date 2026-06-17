//
//  TrackAgentResultClickRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackAgentResultClickRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let intent = "show me healthy snacks"
    fileprivate let searchResultID = "179b8a0e-3799-4a31-be87-127b06871de2"
    fileprivate let itemID = "item123"
    fileprivate let itemName = "Trail Mix"
    fileprivate let variationID = "var123"
    fileprivate let sectionName = "Products"
    fileprivate let intentResultID = "intent-result-123"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackAgentResultClickBuilder() {
        let tracker = CIOTrackAgentResultClickData(intent: intent, searchResultID: searchResultID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_result_click?"))
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertEqual(payload?["search_result_id"] as? String, searchResultID)
        XCTAssertNil(payload?["item_id"])
        XCTAssertNil(payload?["item_name"])
        XCTAssertNil(payload?["variation_id"])
        XCTAssertNil(payload?["intent_result_id"])
    }

    func testTrackAgentResultClickBuilder_WithOptionalParams() {
        let tracker = CIOTrackAgentResultClickData(intent: intent, searchResultID: searchResultID, itemID: itemID, itemName: itemName, variationID: variationID, sectionName: sectionName, intentResultID: intentResultID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertEqual(payload?["search_result_id"] as? String, searchResultID)
        XCTAssertEqual(payload?["item_id"] as? String, itemID)
        XCTAssertEqual(payload?["item_name"] as? String, itemName)
        XCTAssertEqual(payload?["variation_id"] as? String, variationID)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["intent_result_id"] as? String, intentResultID)
    }
}
