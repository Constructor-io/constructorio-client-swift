//
//  TrackAgentSubmitRequestBuilderTests.swift
//  Constructor.io
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

@testable import ConstructorAutocomplete
import XCTest

class TrackAgentSubmitRequestBuilderTests: XCTestCase {

    fileprivate let testACKey = "asdf1213123"
    fileprivate let intent = "show me healthy snacks"
    fileprivate let sectionName = "Products"

    fileprivate var builder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.builder = RequestBuilder(apiKey: testACKey, baseURL: Constants.Query.baseURLString)
    }

    func testTrackAgentSubmitBuilder() {
        let tracker = CIOTrackAgentSubmitData(intent: intent)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertTrue(request.url!.absoluteString.hasPrefix("https://ac.cnstrc.com/v2/behavioral_action/assistant_submit?"))
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertNil(payload?["section"])
        XCTAssertEqual(payload?["beacon"] as? Bool, true)
        XCTAssertEqual(payload?["key"] as? String, testACKey)
        XCTAssertTrue((payload?["c"] as? String)!.contains("cioios-"))
    }

    func testTrackAgentSubmitBuilder_WithSection() {
        let tracker = CIOTrackAgentSubmitData(intent: intent, sectionName: sectionName)
        builder.build(trackData: tracker)
        let request = builder.getRequest()
        let payload = try? JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: Any]

        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(payload?["intent"] as? String, intent)
        XCTAssertEqual(payload?["section"] as? String, sectionName)
    }
}
