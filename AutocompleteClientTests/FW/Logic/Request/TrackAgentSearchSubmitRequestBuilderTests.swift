//
//  TrackAgentSearchSubmitRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackAgentSearchSubmitRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let intent = "show me healthy snacks"
    fileprivate let searchTerm = "trail mix"
    fileprivate let searchResultID = "179b8a0e-3799-4a31-be87-127b06871de2"
    fileprivate let sectionName = "Products"
    fileprivate let intentResultID = "intent-result-123"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackAgentSearchSubmitBuilder() {
        let tracker = CIOTrackAgentSearchSubmitData(intent: intent, searchTerm: searchTerm, searchResultID: searchResultID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/assistant_search_submit?"))
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
        XCTAssertEqual(payload?["search_result_id"] as? String, searchResultID)
        XCTAssertNil(payload?["section"])
        XCTAssertNil(payload?["intent_result_id"])
        XCTAssertNil(payload?["user_input"])
        XCTAssertNil(payload?["group_id"])
    }

    func testTrackAgentSearchSubmitBuilder_WithOptionalParams() {
        let tracker = CIOTrackAgentSearchSubmitData(intent: intent, searchTerm: searchTerm, searchResultID: searchResultID, sectionName: sectionName, intentResultID: intentResultID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertEqual(payload?["search_term"] as? String, searchTerm)
        XCTAssertEqual(payload?["search_result_id"] as? String, searchResultID)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["intent_result_id"] as? String, intentResultID)
    }
}
