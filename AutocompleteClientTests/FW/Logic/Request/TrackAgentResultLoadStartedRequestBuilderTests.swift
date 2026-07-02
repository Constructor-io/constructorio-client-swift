//
//  TrackAgentResultLoadStartedRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackAgentResultLoadStartedRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let intent = "show me healthy snacks"
    fileprivate let sectionName = "Products"
    fileprivate let intentResultID = "179b8a0e-3799-4a31-be87-127b06871de2"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackAgentResultLoadStartedBuilder() {
        let tracker = CIOTrackAgentResultLoadStartedData(intent: intent)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/assistant_result_load_start?"))
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertNil(payload?["section"])
        XCTAssertNil(payload?["intent_result_id"])
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
    }

    func testTrackAgentResultLoadStartedBuilder_WithOptionalParams() {
        let tracker = CIOTrackAgentResultLoadStartedData(intent: intent, sectionName: sectionName, intentResultID: intentResultID)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
        XCTAssertEqual(payload?["intent_result_id"] as? String, intentResultID)
    }
}
